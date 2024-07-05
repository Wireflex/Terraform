resource "aws_eip" "my_static_ip" {
  instance = aws_instance.webserver.id
}
