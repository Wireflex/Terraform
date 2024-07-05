# Переменная региона в variables.tf (terraform apply -var="region=us-east-2" для замены,ну либо в файле)
provider "aws" {
  region = var.region
}

# Хранение .tfstate файла в облаке
terraform {
  backend "s3" {
    bucket = "wireflex-s3"
    key    = "dev/webserver/terraform.tfstate"
    region = "eu-central-1"
  }
}

# Создание vpc
resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.10.1.0/24"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Production VPC"
  }
}

#================================================================#
# Переделывание сети в публичную

# Создание маршрутной таблицы
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.prod_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prod.id
    }
}

# Cвязывание её с сабнетом и добавление маршрута к интернет-шлюзу
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.prod_subnet.id
  route_table_id = aws_vpc.prod_vpc.main_route_table_id
}

resource "aws_route" "internet_gateway" {
  route_table_id         = aws_vpc.prod_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.prod.id
}
#================================================================#

# Присоединяем VPC к интернет-шлюзу
resource "aws_internet_gateway" "prod" {
  vpc_id = aws_vpc.prod_vpc.id
}

# Получение "информации" об образе ubuntu:latest(Вывод в outputs.tf, и потом в инстансе укажем это,но эта хрень платная, лучше халявный имедж взять)
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# Доступные зоны в регионе ( Вывод в outputs.tf )
data "aws_availability_zones" "working" {}

# ID аккаунта ( Вывод в outputs.tf )
data "aws_caller_identity" "current" {}

# Регион,в котором работаем( 2 вывода(имя и описание) в outputs.tf )
data "aws_region" "current" {}

# ID vpc,в котором работаем ( Вывод в outputs.tf )
data "aws_vpcs" "my_vpcs" {}

# Создание subnet, из данных выше
resource "aws_subnet" "prod_subnet" {
  vpc_id            = aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.10.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name    = "Subnet in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

# Статический IP для инста( при перезапуске будет сохраняться )
resource "aws_eip" "static_ip" {
  instance = aws_instance.webserver[0].id
}

# Создание security group с динамическим ingress(22,80,443) переменные в variables.tf
resource "aws_security_group" "webserver" {
  name   = "My Security Group"
  vpc_id = aws_vpc.prod_vpc.id
  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.common_tags
}

# Создание инстанса, образ берём из data выше. Переменные в variables.tf
resource "aws_instance" "webserver" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.prod_subnet.id
  key_name      = "private-ssh-key"
  count         = 1 
  vpc_security_group_ids = [aws_security_group.webserver.id]             # Связали инст с группой
  user_data_replace_on_change = true
  user_data = file("./user_data.sh")
  tags = merge(var.common_tags, { Name = "Wireflex's server" })
  # depends_on = [aws_instance.another_resourse]
    
  lifecycle {
    create_before_destroy = true
  }
}
