variable "region" {
  description = "Please Enter AWS Region to deploy Server"
  type        = string
  default     = "eu-central-1"                              # Если нужно изменить default при запуске,тогда в строке terraform apply -var="region=us-east-2"
}

