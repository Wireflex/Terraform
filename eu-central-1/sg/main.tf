terraform {
  backend "s3" {
    bucket         = "aws-terraform-state-backend"
    key            = "eu-central-1/sg/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "aws-terraform-state-locks"
    encrypt        = true
  }
}


provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "TerminationDate" = "Permanent",
      "Environment"     = "Development",
      "Team"            = "DevOps",
      "DeployedBy"      = "Terraform",
      "Description"     = "For General Purposes"
      "OwnerEmail"      = "devops@example.com"
    }
  }
}

data "terraform_remote_state" "vpc" {          # берем данные из впс, созданной 1ой
  backend = "s3"
  config = {
    bucket = "aws-terraform-state-backend"
    key    = "eu-central-1/vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_security_group" "sg" {
  name        = "dota-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id   # это из аутпута берём
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Dota-SG-SSH"
  }
}
