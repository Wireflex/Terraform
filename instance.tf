Дефолт
resource "aws_instance" "webserver" {
  ami           = "ami-0a3041ff14fb6e2be"
  instance_type = "t2.micro"
  key_name      = "wireflex-key-frankfurt"

  vpc_security_group_ids = [aws_security_group.webserver.id]       # Название security group(webserver) может быть другое,это не instance !!!
  }
