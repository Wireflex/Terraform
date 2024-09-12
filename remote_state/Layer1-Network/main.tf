# штука нужна для того, чтобы хранить tfstate file удалённо, к примеру, в s3-bucket, а не локально 
# идея нескольких layer состоим в том, чтобы 1 чел настраивал в layer-1: s3,vpc,sgroup и output'ом выводил инфу для следующего чела,а 2ой чел в layer-2 уже делал чет другое( сервы поднимал итд)
provider "aws" {
  region = "eu-central-1"
}

# Для начала создаём сам s3-bucket в амазоне и ниже указываем его параметры

terraform {
  backend "s3" {
    bucket = "wireflex-s3-bucket"                        // название бакета
    key    = "dev/network/terraform.tfstate"             // нужно придумать путь к файлу
    region = "eu-central-1"                              // регион, в котором создали бакет
  }
}

#==============================================================

data "aws_availability_zones" "available" {}      # просто получаем данные, можно потом юзать где угодно, вывести output'ом, в этом примере юзается в aws_subnet ниже

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr      # "10.0.0.0/16", в переменных указано всё
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-igw"
  }
}


resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)   # в variables.tf 2 шт. cidrs
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)   # тут уже названия тех 2х cidrs из variables.tf
  availability_zone       = data.aws_availability_zones.available.names[count.index]   # в каждой availability_zone создадим
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-puvlic-${count.index + 1}"
  }
}


resource "aws_route_table" "public_subnets" {          # создаём aws_route_table для выхода в интернет
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env}-route-public-subnets"
  }
}

resource "aws_route_table_association" "public_routes" {         # приатачиваем созданный table к subnets
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}

#==============================================================
