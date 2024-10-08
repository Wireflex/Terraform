# это плагин, который позволяет Terraform взаимодействовать с API различных облачных платформ и сервисов. Он обеспечивает возможности для управления ресурсами (например, серверами, базами данных, сетями) и определяет, как Terraform должен создать, обновить или удалить эти ресурсы.

Тупой способ, так как видно ключи

provider "aws" {
    access_key = "12345"
    secret_key = "12345"
    region     = "blablabla"
}
#=================================================================================# 

Это когда залогинен или экспортнул данные

provider "aws" {}

  default_tags {             # эти дефолт таги будут для всех ресурсов, в отличие от common tags, которые в самих ресурсах указывается
    tags = {
      Owner     = "Wireflex"
      CreatedBy = "Terraform"
    }
  }
}
#=================================================================================# 

Использование переменных(сами переменные в файле variables.tf)

provider "aws" {
  region = var.region
}

#=================================================================================# 

Использование другого AWS аккаунта и если есть несколько провайдеров и сервов,чтобы серв обращался к определенному провайдеру по его alias

provider "aws" {
  alias      = "ANOTHER_AWS_ACCOUNT"
  region     = "ca-central-1"
  access_key = "xxxxxxxxxxxx"
  secret_key = "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
Либо ключи, либо роль
  assume_role {
    role_arn     = "arn:aws:iam::1234567890(айди акка):role/RemoteAdministrators"
    session_name = "TERRAFROM_SESSION"
  }
}
...
instance : provider    = aws.ANOTHER_AWS_ACCOUNT
...
