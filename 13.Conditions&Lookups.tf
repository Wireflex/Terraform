# Conditions (Условия) выглядит так:

X = CONDITION ? VALUE_IF_TRUE : VALUE_IF_FALSE

provider "aws" {
  region = "eu-central-1"
}

resource "aws_default_vpc" "default" {}

// Use of Condition
resource "aws_instance" "my_webserver1" {
  ami = "ami-03a71cec707bfc3d7"
  instance_type = var.env == "prod" ? "t2.large" : "t2.micro"                        # 1ый варик обычный, если продакшн - то нужен большой t2.large, если нет - то хватит и t2.micro
  instance_type = var.env == "prod" ? var.ec2_size["prod"] : var.ec2_size["dev"]     # 2ой варик с переменными, 
  
  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_onwer : var.noprod_owner
  }
}



#================= Use of LOOKUP===========================================#

X = lookup(map,key)

resource "aws_instance" "my_webserver2" {
  ami           = "ami-03a71cec707bfc3d7"
  instance_type = lookup(var.ec2_size, var.env)          # то есть дефолт у нас dev, снизу смотрим в variables, значит, будет t3.micro

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_onwer : var.noprod_owner
  }
}


// Create Bastion ONLY for if "dev" environment
resource "aws_instance" "my_dev_bastion" {
  count         = var.env == "dev" ? 1 : 0         # если дев, то создаст серв(1 шт), если что-то другое то нифига
  ami           = "ami-03a71cec707bfc3d7"
  instance_type = "t2.micro"

  tags = {
    Name = "Bastion Server for Dev-server"
  }
}



resource "aws_security_group" "my_webserver" {
  name   = "Dynamic Security Group"
  vpc_id = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
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

  tags = {
    Name  = "Dynamic SecurityGroup"
    Owner = "Denis Astahov"
  }
}


#=========ПЕРЕМЕННЫЕ ДЛЯ CONDITIONS AND LOOKUPS===========================#

variable "env" {
  default = "dev"
}

variable "prod_onwer" {
  default = "Denis Astahov"
}

variable "noprod_owner" {
  default = "Dyadya Vasya"
}

variable "ec2_size" {
  default = {
    "prod"    = "t3.medium"
    "dev"     = "t3.micro"
    "staging" = "t2.small"
  }
}

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}
