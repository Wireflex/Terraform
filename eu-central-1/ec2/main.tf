terraform {
  backend "s3" {
    bucket         = "aws-terraform-state-backend"
    key            = "eu-central-1/ec2/terraform.tfstate"
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
      "Type"            = "Compute Cloud"
    }
  }
}

data "terraform_remote_state" "vpc" {     # берем данные из впс, которую создали 1ой
  backend = "s3"
  config = {
    bucket = "aws-terraform-state-backend"
    key    = "eu-central-1/vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "sg" {     # берем данные из сг, которую создали 2ой
  backend = "s3"
  config = {
    bucket = "aws-terraform-state-backend"
    key    = "eu-central-1/sg/terraform.tfstate"
    region = "eu-north-1"
  }
}

module "ec2_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "dota"
  instance_type          = "t3.micro"
  ami                    = "ami-0f0b4cb72cf3eadf3"
  vpc_security_group_ids = [data.terraform_remote_state.sg.outputs.sg_id]               # здесь их и
  subnet_id              = data.terraform_remote_state.vpc.outputs.private_subnets[0]   # подставляем
  tags = {
    Name = "dota"
  }
}
