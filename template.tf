Эта штука нужна для заполнения index.html в файле user_data.sh.tpl( который в репозитории user_data.sh )

resource "aws_instance" "webserver" {
  ami           = "ami-0a3041ff14fb6e2be"
  instance_type = "t2.micro"
  key_name      = "private-ssh-key"

  vpc_security_group_ids = [aws_security_group.webserver.id]
  user_data_replace_on_change = true
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Nikita",
    l_name = "Utyaganov",
    names  = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha"]
  })

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Wireflex"
  }
}
