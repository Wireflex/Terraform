Дефолт

resource "aws_instance" "webserver" {
  ami           = "ami-0a3041ff14fb6e2be"                          # Образ амазон сервера(red hat), во время launch instance можно посмотреть
  instance_type = "t2.micro"                                       # халявное 1 ядро,1 гиг рама,игровая видеокарта
  key_name      = "ssh-private-key"                                # private ssh key
  count         = 1                                                # Количество 
  vpc_security_group_ids = [aws_security_group.webserver.id]       # Название security group(webserver) может быть другое,это не instance !!!
  depends_on = [aws_instance.my_server_db]                         # Запустится после инста my_server_db
  }

#=================================================================================#

Добавление user_data ( выполнится башем после запуска инста )

resource "aws_instance" "webserver" {
  ami           = "ami-0a3041ff14fb6e2be"
  instance_type = "t2.micro"
  key_name      = "ssh-private-key"

  vpc_security_group_ids = [aws_security_group.webserver.id]

  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install httpd -y
echo "<h1>Hello from Terraform-managed webserver!</h1>" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
  EOF
}
#=================================================================================#

Lifecycles

  lifecycle {
    prevent_destroy = true
  }

  lifecycle {
    ignore_changes = ["ami", "user_data"]
  }

  lifecycle {
    create_before_destroy = true
  }
