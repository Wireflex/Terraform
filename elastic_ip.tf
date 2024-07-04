resource "aws_eip" "my_static_ip" {
  vpc      = true
  instance = aws_instance.allow_http_https_ssh.id
}
