Тупой способ, так как видно ключи

provider "aws" {
    access_key = "12345"
    secret_key = "12345"
    region     = "blablabla"
}
#=================================================================================# 

Это когда залогинен или экспортнул данные

provider "aws" {}

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

  assume_role {
    role_arn     = "arn:aws:iam::1234567890:role/RemoteAdministrators"
    session_name = "TERRAFROM_SESSION"
  }
}
...
instance : provider    = aws.ANOTHER_AWS_ACCOUNT
...
