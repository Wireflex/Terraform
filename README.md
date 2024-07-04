![image](https://github.com/Wireflex/Terraform/assets/165675775/e64fc968-9c50-4804-a8f5-542e7c1e7a2c)

[Уроки по Terraform от ADV-IT](https://www.youtube.com/watch?v=R0CaxXhrfFE&list=PLg5SS_4L6LYujWDTYb-Zbofdl44Jxb2l8)

[Install Terraform](https://developer.hashicorp.com/terraform/install) Linux - Binary download - ```wget``` - ```unzip``` - ```sudo mv terraform /bin/``` - ```terraform --version``` ( обновить - по сути сделать тож самое, заменив старую версию )

или же [Зеркало](https://mirror.selectel.ru/3rd-party/hashicorp-releases/terraform/?_gl=1*g62yz3*_gcl_au*MjAxODM3ODkzMy4xNzEyMDkyODA4*_ga*MTk5NDU1NjA3Ni4xNzEyMDkyODA4*_ga_H3R3VJH01B*MTcxOTU2OTk1NS4xOS4wLjE3MTk1Njk5NTUuNjAuMC4w) , но по сути оно бесполезно,т.к на ру-сервах терраформ не работает

В качестве написания кода, для удобства, можно использовать [Visual Studio Code](https://code.visualstudio.com/download) прям на винде, копируя код, либо сохраняя и загружая через Mobaxterm, + нужен HashiCorp Terraform плагин ( File-Preferences-Settings-Text Editor-Formatting-Format of save )

### Устанавливаем AWS Credentials
```
export AWS_ACCESS_KEY_ID="12345"
export AWS_SECRET_ACCESS_KEY="12345"
export AWS_DEFAULT_REGION="blablabla"
```
или 
```aws configure``` и вводим ключи и регион, полученные при создании пользователя в AWS ( можно их и потом добавить/поменять юзеру )

### Команды Terraform
```
terraform init - в директории с .tf файлом перед деплоем, скачивает бинарник для работы с AWS(Google,Azure)
```
terraform plan
terraform apply
terraform destroy
```
