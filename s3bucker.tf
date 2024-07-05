Создание файлов в бакете, к примеру сначала делаем сеть, и выводим айди сети, которую потом юзаем во время создания группы

provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "metori-s3"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
    Name = "My VPC"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}
#============================================================#

Это уже берём данные из бакета, создаём группу и так же файлы создаём в бакете,чтобы,условно,дальше поднять инстанс,использовав данные из группы

provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "metori-s3"
    key    = "dev/servers/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "metori-s3"
    key    = "dev/network/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_security_group" "webserver" {
  name = "WebServer Security Group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
}

egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

tags = {
    Name = "web-server"
    Owner = "Wireflex"
 }
}

output "webserver_sg_id" {
  value = aws_security_group.webserver.idы
}
