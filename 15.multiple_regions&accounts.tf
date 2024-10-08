# когда в 1 файле хотим создать в нескольких регионах/несколько акков

provider "aws" { // This is example to use Another AWS Account
  alias      = "ANOTHER_AWS_ACCOUNT"
  region     = "ca-central-1"
  access_key = "xxxxxxxxxxxx"
  secret_key = "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"

  assume_role {
    role_arn     = "arn:aws:iam::1234567890:role/RemoteAdministrators"
    session_name = "TERRAFROM_SESSION"
  }
}

# сразу несколько провайдеров с алиасами, которые потом будут в инстансах

provider "aws" {
  region = "ca-central-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "USA"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "GER"
}
#==================================================================

data "aws_ami" "defaut_latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "usa_latest_ubuntu" {
  provider    = aws.USA          # будет искать в USA
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "ger_latest_ubuntu" {
  provider    = aws.GER
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

#============================================================================
resource "aws_instance" "my_default_server" {
  instance_type = "t3.micro"
  ami           = data.aws_ami.defaut_latest_ubuntu.id
  tags = {
    Name = "Default Server"
  }
}

resource "aws_instance" "my_usa_server" {
  provider      = aws.USA                    # это элиас из блока providers
  instance_type = "t3.micro"
  ami           = data.aws_ami.usa_latest_ubuntu.id
  tags = {
    Name = "USA Server"
  }
}

resource "aws_instance" "my_ger_server" {
  provider      = aws.GER
  instance_type = "t3.micro"
  ami           = data.aws_ami.ger_latest_ubuntu.id
  tags = {
    Name = "GERMANY Server"
  }
}
