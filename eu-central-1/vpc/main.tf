terraform {
  backend "s3" {
    bucket         = "aws-terraform-state-backend"
    key            = "eu-central-1/vpc/terraform.tfstate"
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
      "Type"            = "Networking"
    }
  }
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  name                   = "Dev-VPC"
  cidr                   = "10.10.0.0/16"
  azs                    = data.aws_availability_zones.available.names
  private_subnets        = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets         = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
