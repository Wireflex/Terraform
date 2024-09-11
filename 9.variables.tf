variable "region" {
  description = "Please Enter AWS Region to deploy Server"
  type        = string
  default     = "eu-central-1"                              # Если нужно изменить default при запуске,тогда в строке terraform apply -var="region=us-east-2"
}

variable "instance_type" {
  description = "Enter Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list
  default     = ["80", "443", "22"]
}

variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map
  default = {
    Owner       = "Wireflex"
    CostCenter  = "12345"
    Environment = "development"
  }
}


#==============================================================#

так же можно экспортить как переменную окружения

export var_region=eu-central-1
