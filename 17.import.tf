# Импортим другой ресурс, созданный вручную в АВС, к примеру

создаём ресурсы, которые импортнём:

```
resource "aws_security_group" "main" {
  # ID существующей Security Group
  import = "aws_security_group.sg-1234567890abcdef0"

  # Оставьте пустым, если вы не хотите изменять настройки Security Group
  # name = "my-security-group"
  # description = "My security group"
}

resource "aws_instance" "instance_1" {
  # ID существующего EC2 Instance
  import = "aws_instance.i-1234567890abcdef0"

  # Оставьте пустым, если вы не хотите изменять настройки Instance
  # ami = "ami-08c40714d31428882"
  # instance_type = "t2.micro"
}
```

terraform init

terraform import aws_security_group.main sg-1234567890abcdef0   # (SG ID)

terraform import aws_instance.instance_1 i-1234567890abcdef0  # ( Instance ID)
