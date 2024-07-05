resource "aws_eip" "my_static_ip" {
  vpc      = true
  instance = aws_instance.webserver.id
}
