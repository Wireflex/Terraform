![image](https://github.com/user-attachments/assets/587a3427-bf22-4804-956e-639f847e2f2d)

это система управления состоянием инфраструктуры, придерживающаяся подхода идемпотентности и декларативного стиля управления.

[Install Terraform](https://developer.hashicorp.com/terraform/install#linux) ```wget``` - ```unzip``` - ```sudo mv terraform /bin/``` - ```terraform --version``` ( обновить - по сути сделать тож самое, заменив старую версию )

[Зеркало](https://mirror.selectel.ru/3rd-party/hashicorp-releases/terraform/?_gl=1*g62yz3*_gcl_au*MjAxODM3ODkzMy4xNzEyMDkyODA4*_ga*MTk5NDU1NjA3Ni4xNzEyMDkyODA4*_ga_H3R3VJH01B*MTcxOTU2OTk1NS4xOS4wLjE3MTk1Njk5NTUuNjAuMC4w) , но вообще оно юзлесс, т.к на ру-сервах терраформ не работает

или же просто 
```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

В качестве написания кода, для удобства, можно использовать [Visual Studio Code](https://code.visualstudio.com/download) + нужен HashiCorp Terraform плагин ( File-Preferences-Settings-Text Editor-Formatting-Format of save ) язык - HCL ( Hashicorp Configuration Language )

Инфу, примеры групп, инстансов, параметры дата сурс итд можно смотреть в [Terraform Registry](https://registry.terraform.io/) , работает с vpn

### Устанавливаем AWS Credentials

[AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

<details> <summary><kbd>Ctrl</kbd>+<kbd>C</kbd> and <kbd>Ctrl</kbd> + <kbd>V</kbd></summary>
  
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
</details>

```aws configure``` и вводим ключи и регион, полученные при создании пользователя в AWS

или 

```
export AWS_ACCESS_KEY_ID="12345"
export AWS_SECRET_ACCESS_KEY="12345"
export AWS_DEFAULT_REGION="blablabla"
```

## Terraform Commands

основные команды Terraform

```terraform init```      # в директории с .tf файлом перед деплоем, скачивает бинарник для работы с клауд провайдером, создаёт ".terraform.lock.hcl" файл, который хранит инфу о провайдере и хэш модулей

```terraform plan```      # проверяет и показывает,что сделает в случае apply

```terraform apply```     # создание ресурсов, создаёт terraform.tfstate файл, для пересоздания ресурса - добавляем ```-replace aws_instance.myweb1

```terraform destroy```   # уничтожение ресурсов

```terraform validate```  # проверка синтаксиса конфигурационных файлов

```terraform refresh```   # обновление данных о существующих ресурсах в аккаунте AWS

```terraform output```    # просто выведет outputs, без создания других ресурсов

```terraform console```   # для теста, file("user_data.sh.tpl") выдаст контент скрипта 

```terraform show```      # читает tfstate файл и отображает его

## Terraform State Commands

используются для управления состоянием инфраструктуры, которое хранится в файле terraform.tfstate. Этот файл содержит всю информацию о ресурсах, которые были созданы и управляются Terraform.

```terraform state show```   # Показывает стейт ресурса ( aws_instance.webserver, к примеру ) Read only

```terraform state list```   # Показывает все ресурсы в .tfstate файле. Read only

```terraform state pull```   # Читает весь .tfstate и выводит на экран. Read only

```terraform state rm```    # Удаляет ресурс. Attention !!!

```terraform state mv```    # Двигает ресурс. Attention !!! terraform state mv -state-out="terraform.tfstate" aws_eip.prod-ip1 aws_eip.prod-ip1 (перенос из ремоут в локальный с тем же именем)

```terraform state push```  # Перезаписывает .tfstate, который был. Attention !!!

## Terraform Workspace Commands

команды для тестирования, после создания workspace появляется директория env: , и там хранятся все воркспейсы

```terraform workspace show```         # показывает текущий воркспейс( default )

```terraform workspace list```         # показывает все воркспейсы

```terraform workspace new```dota      # создайт воркспейс 'dota'

```terraform workspace select```dota   # переход на воркспейс 'dota'

```terraform workspace delete```dota   # удаление воркспейса 'dota'

## [Terraform Cloud](https://app.terraform.io/app/organizations)

можно привязать SCM к клауду, и в случае GitOps будет чем-то вроде ci/cd инструмента, с pull-request итд
