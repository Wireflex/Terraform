variable "region" {
  description = "Please Enter AWS Region to deploy Server"
  type        = string
  default     = "eu-central-1"
}

variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list
  default     = ["22", "80", "443"]
}

variable "instance_type" {
  description = "Enter Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map
  default = {
    Owner       = "Wireflex"
    Environment = "development"
  }
}
