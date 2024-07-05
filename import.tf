Импортим другой ресурс

terraform import aws_instance.node1 i-0417da3dfcfd6e059
либо
resource "aws_instance" "node1" {
}

#===========================================================#
Но нужно всё равно его прописывать в конфиге,мутная штука

resource "aws_instance" "node1" {
  ami                    = "ami-0a634ae95e11c6f91"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.nomad.id]
  ebs_optimized          = true
  tags = {
    Name  = "Nomad Ubuntu Node-1"
    Owner = "Denis Astahov"
  }
}
