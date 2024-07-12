# Этот блок указывает Terraform использовать провайдер AWS для управления ресурсами в облаке Amazon Web Services.
provider "aws" {}

# В этом блоке используется data source aws_availability_zones для получения списка доступных зон доступности в выбранном регионе AWS.
data "aws_availability_zones" "working" {}

# В этом блоке определены глобальные настройки Terraform, такие как настройки бекенда для хранения состояния и регион, в котором будут создаваться ресурсы.
terraform {
  backend "s3" {
    bucket = "wireflex-s3"
    key    = "dev/webserver/terraform.tfstate"
    region = "eu-central-1"
  }
}

# В этом блоке создается виртуальная частная облако (VPC) с заданным диапазоном CIDR, активированным DNS-сервисом и заданными тегами.
resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.10.1.0/24"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Production VPC"
  }
}

# Этот блок создает интернет-шлюз и присоединяет его к ранее созданной VPC.
resource "aws_internet_gateway" "prod" {
  vpc_id = aws_vpc.prod_vpc.id
}

# В этом блоке создается маршрутная таблица для VPC, в которой устанавливается маршрут по умолчанию через интернет-шлюз.
resource "aws_route_table" "prod_rt" {
    vpc_id = aws_vpc.prod_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prod.id
    }
}

# В этом блоке создается подсеть в выбранной зоне доступности с заданными параметрами, включая возможность использования публичных IP-адресов.
resource "aws_subnet" "prod_subnet" {
  vpc_id            = aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.10.1.0/24"
  map_public_ip_on_launch = true
}

# Этот блок ассоциирует ранее созданную маршрутную таблицу с публичной подсетью.
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.prod_subnet.id
  route_table_id = aws_route_table.prod_rt.id
}

# В этом блоке создается группа безопасности с заданными правилами входящего трафика (SSH, HTTP, HTTPS) и разрешением всего исходящего трафика.
resource "aws_security_group" "webserver" {
  name   = "My Security Group"
  vpc_id = aws_vpc.prod_vpc.id
  dynamic "ingress" {
    for_each = ["22", "80", "443"]
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
}

# В этом блоке создаются экземпляры веб-сервера с использованием заданных AMI, типа экземпляра, подсети, ключа SSH и группы безопасности. Параметр count устанавливает количество создаваемых экземпляров.
resource "aws_instance" "webserver" {
  ami           = "ami-0e872aee57663ae2d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.prod_subnet.id
  key_name      = "wireflex-key-frankfurt"
  count         = 2 
  vpc_security_group_ids = [aws_security_group.webserver.id]
    
  lifecycle {
    create_before_destroy = true
  }
}
