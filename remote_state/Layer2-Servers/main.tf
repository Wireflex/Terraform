# 2ой чел в layer-2 использует данные из layer-1 ( outputs vpc_cidr, vpc_id итд), сами outputs в файле outputs.tf) , можно вывести командой ```terraform output```

provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "wireflex-s3-bucket"                        // мы, опять же, будет сохранять всё в s3
    key    = "dev/servers/terraform.tfstate"             // но уже в servers
    region = "eu-central-1"                              // тот же регион
  }
}
#====================================================================

# а здесь уже мы не сохраняем, а берём инфу из s3-bucket'а, который создал чел на Layer-1

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "wireflex-s3-bucket"                        // Бакет, откуда берём tfstate
    key    = "dev/network/terraform.tfstate"             // Тот путь, который указывал 1ый чел в layer-1
    region = "eu-central-1"                              // регион где был создан бакет
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
#===============================================================


resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform with Remote State"  >  /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
  tags = {
    Name = "${var.env}-WebServer"
  }
}

resource "aws_security_group" "webserver" {
  name = "WebServer Security Group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id          # берём данные из outputs, которые были выведены в layer-1

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "${var.env}-web-server-sg"
    Owner = "Denis Astahov"
  }
}
