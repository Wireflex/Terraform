Дефолт

resource "aws_instance" "webserver" {
  ami           = "ami-0a3041ff14fb6e2be"                          # Образ убунты, во время launch instance можно посмотреть
  instance_type = "t2.micro"                                       # халявное 1 ядро,1 гиг рама,игровая видеокарта
  key_name      = "privatnii kluch"                                # private ssh key
  count         = 1                                                # Количество 
  vpc_security_group_ids = [aws_security_group.webserver.id]       # Название security group(webserver) может быть другое,это не instance !!!
  }

