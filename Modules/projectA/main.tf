# несколько сетей создадим, используя один модуль aws_network

provider "aws" {
  region = var.region
}

module "vpc-default" {  # просто название
  source = "../aws_network"  # путь к модулю
  //  source               = "git@github.com:adv4000/terraform-modules.git//aws_network"
}

module "vpc-dev" {
  source = "../modules/aws_network"
  //  source               = "git@github.com:adv4000/terraform-modules.git//aws_network"
  env                  = "dev"                                   # к НЕдефолтному модулю можно переслать параметры, которые перепишут дефолтные значения, то есть env тут будет другой, в сети ниже 3ий, итд
  vpc_cidr             = "10.100.0.0/16"
  public_subnet_cidrs  = ["10.100.1.0/24", "10.100.2.0/24"]
  private_subnet_cidrs = []
}

module "vpc-prod" {
  source = "../modules/aws_network"
  // source               = "git@github.com:adv4000/terraform-modules.git//aws_network"
  env                  = "prod"
  vpc_cidr             = "10.10.0.0/16"
  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.22.0/24", "10.10.33.0/24"]
}

module "vpc-test" {
  source = "../modules/aws_network"
  // source               = "git@github.com:adv4000/terraform-modules.git//aws_network"
  env                  = "staging"
  vpc_cidr             = "10.10.0.0/16"
  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.11.0/24", "10.10.22.0/24"]
}



#============================= это переменные в модуле aws_network/variables.tf, чтоб просто перед глазами были =======================#
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "env" {
  default = "dev"
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

variable "private_subnet_cidrs" {
  default = [
    "10.0.11.0/24",
    "10.0.22.0/24",
    "10.0.33.0/24"
  ]
}
