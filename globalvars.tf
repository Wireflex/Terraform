Сохраняем глобальные переменные в с3 бакете

provider "aws" {
  region = "ca-central-1"
}

terraform {
  backend "s3" {
    bucket = "denis-astahov-project-kgb-terraform-state"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

#==================================================

output "company_name" {
  value = "ANDESA Soft International"
}

output "owner" {
  value = "Wireflex"
}

output "tags" {
  value = {
    Project    = "Assembly-2077"
    CostCenter = "R&D"
    Country    = "Canada"
  }
}

#==========================================================================#

Используем их,чтобы сделать локальные,а локальные уже юзаем как обычно

provider "aws" {
  region = "ca-central-1"
}

data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "metori-s3"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  company_name = data.terraform_remote_state.global.outputs.company_name
  owner        = data.terraform_remote_state.global.outputs.owner
  common_tags  = data.terraform_remote_state.global.outputs.tags
}
#---------------------------------------------------------------------

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name    = "Stack1-VPC1"
    Company = local.company_name
    Owner   = local.owner
  }
}


resource "aws_vpc" "vpc2" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(local.common_tags, { Name = "Stack1-VPC2" })
}
