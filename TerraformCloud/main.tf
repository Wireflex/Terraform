provider "aws" {}

resource "aws_instance" "webserver" {
  ami           = "ami-0e872aee57663ae2d"
  instance_type = "t2.micro"
  key_name      = "wireflex-key-frankfurt"
}
