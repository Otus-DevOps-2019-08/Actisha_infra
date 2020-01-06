
#win Actisha_infra
Actisha Infra repository


#### #HW1 Git
First PR

#### #HW2 ChatOps
Integration: GitHub, Slack, Travis
travis encrypt "devops-team-otus:<token>#<user-group>" --add notifications.slack.rooms --com

#### #HW3 GCP
[actisha@localhost ~]$ cat /etc/hosts
*nix
34.76.93.197 bastion
10.132.0.3  someinternal

Win
C:\Users\Hanna>type C:\Windows\System32\drivers\etc\hosts
34.76.93.197 bastion
10.132.0.3  someinternal

*nix
[actisha@localhost ~]$ cat ~/.ssh/config
Host bastion
  Hostname bastion
  User appuser
  IdentityFile ~/.ssh/appuser
Host someinternal
  Hostname someinternal
  User appuser
  ProxyCommand ssh -W %h:%p bastion
  IdentityFile ~/.ssh/appuser

[actisha@localhost ~]$ ssh someinternal
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-1042-gcp x86_64)
 
  
Win
C:\Users\Hanna>type C:\Users\Hanna\.ssh\config
Host bastion
  Hostname bastion
  User appuser
  IdentityFile ~/.ssh/appuser
Host someinternal
  Hostname someinternal
  User appuser
  ProxyCommand ssh -W %h:%p bastion
  IdentityFile ~/.ssh/appuser

Hanna@LAPTOP /c/repos
$ ssh someinternal
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-1042-gcp x86_6

34.76.93.197 bastion
10.132.0.3  someinternal

bastion_IP = 34.76.93.197
someinternalhost_IP = 10.132.0.3

---------------------------
Развертывание mongodb и printul с помощью готового setupvpn.sh (файл, описывающий установку VPN-сервера)
$ sudo bash setupvpn.sh

Подключение по конфигу:
sudo openvpn --config /etc/openvpn/client/otus_test_testsrv.ovpn

Last login: Tue Oct  1 15:25:42 2019 from laptop-nkm50cmp.mymifi
[actisha@localhost ~]$ ssh -i ~/.ssh/appuser appuser@10.132.0.3
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-1042-gcp x86_64)

---------------------------
Web-морда VPN (большое спасибо Svetozar за предоставленную возможность :))
https://hannamonty.systemctl.tech/

#### #HW4 GCP testapp
Установка Google Cloud SDK и создание нового инстанса reddit-app

gcloud compute instances create reddit-app
--boot-disk-size=10GB
--image-family ubuntu-1604-lts
--image-project=ubuntu-os-cloud
--machine-type=g1-small
--tags puma-server
--restart-on-failure

testapp_IP = 34.77.75.82 
testapp_port = 9292  


Подключение к серверу
ssh appuser@reddit-app

Установка Ruby и Bundler

---------------------------
$ sudo apt update
$ sudo apt install -y ruby-full ruby-bundler build-essential

ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
Bundler version 1.11.2

Установка MongoDB

---------------------------
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

Деплой приложения

---------------------------
Выполнить в домашней директории appuser git clone -b monolith https://github.com/express42/reddit.git
Устанавливаем зависимости приложения cd reddit && bundle install
Запуск СП puma -d
Проверка порта ps aux | grep puma
9292

Открываем порт в файрволе (GPC)
Для проверки перейти http://34.77.75.82:9292/

Создаем исполняемые скрипты для запуска команд выше (*.sh)
Копируем на наш инстанс все необходимые файлы
scp install_ruby.sh appuser@reddit-app:/home/appuser/

Создание инстансов и установка необходимого ПО

---------------------------
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure
  --metadata-from-file startup-script-url=/home/appuser/startup_script.sh

Работа с правилами

---------------------------
default-puma-server

gcloud compute firewall-rules create default-puma-server\
  --allow=tcp:9292 \
  --source-ranges="0.0.0.0/0" \
  --target-tags=puma-server \

#### #HW5 GCP. Packer
Выполнен перенос скриптов из предыдущего ДЗ в каталог config-scripts.

В каталог packer/scripts/  скопированы скрипты: 
install_mongodb.sh  
install_ruby.sh   

Установлен packer.
Создан Packer шаблон (ubuntu16.json), с помощью которого собираем наш образ с предустановленными Ruby и MongoDB.
Выполнена проверка валидности созданного шаблона - ```packer validate ./ubuntu16.json.```
Запуск билда - ```packer build ubuntu16.json```
Запуск приложения:
```
ssh appuser@104.199.106.99
git clone -b monolith https://github.com/express42/reddit.git  
cd reddit && bundle install  
puma -d
```
Проверка подключения - http://104.199.106.99:9292/
35.205.128.239

Параметризованы переменные в variables.json, файл добавлен в .gitignore.
Проверка запуска - packer build -var-file variables.json ubuntu16.json.
Полет нормальный. 

---------------------------
HW5 - 1*
Создание ```immutable.json``` с описанием образа reddit-full.
В ```packer/files/deploy.sh``` описана установка приложения.
Запуск установки:
 ```sh
 packer build -var-file variables.json immutable.json
 ```
HW5 - 2*
Cкрипт config-scripts/create-reddit-vm.sh  
 ```sh
 gcloud compute instances create reddit-app-full\
  --image-family reddit-full \
  --image-project=infra-254414 \
  --tags puma-server \
  --restart-on-failure
```
Проверка подключения - http://35.205.128.239:9292/

#### #HW6 Terraform 1

Скачивание Terraform:
```sudo wget https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip```

Распаковка:
```sudo unzip ./terraform_0.12.18_linux_amd64.zip –d /usr/local/bin```

Загружен провайдер ```terraform init``` Terraform, созданы файлы описания инфраструктуры **main.tf**, описание выходных переменных **outputs.tf**, директория files, файлы **puma.service**, **deploy.sh**.
Структура **main.tf**:
- *Provider* - позволяет управлять ресурсами GCP через API.
- *Resource* - управление ресурсами различных сервисов GCP.
   - ресурс "google_compute_instance" "name" - для управления инстансами.
      provisioner "name" - для запуска инструментов управления конфигурацией или начальной настройки системы.
      connection - параметры подключения провиженеров к VM.
   - ресурс "google_compute_firewall" "name" - определяет правило для firewall.

Перед внесением изменений - проверить какие изменения планируется провести:
```terraform plan```
Принять изменения:
```terraform apply```
Поиск атрибутов из state файла:
```terraform show | grep nat_ip```
Определение ssh ключа:
```metadata = {
     ssh-keys = "appuser:${file("~/.ssh/appuser.pub")}"
  }```
Обновление значения выходной переменной:
```terraform refresh```
Просмотр значения выходной переменной:
```terraform output
terraform output app_external_ip
```
Чтобы пометить ресурс, который terraform должен пересоздать, при следующем запуске terraform apply:
```terraform taint google_compute_instance.app
terraform plan
terraform apply
```
Создан файл для описания входных переменных (**variables.tf**).
Создан файл для определения входных переменных (**terraform.tfvars**).
Проверка подключения - http://104.199.106.99:9292/

Команда для удаления всех созданных ресурсов:
```terraform destroy```

Проверка подключения после пересоздания - http://35.241.186.18:9292/

---------------------------
##Самостоятельное задание

Определена input переменная для приватного ключа, использующегося в определении подключения для провижинеров (connection). Для этого:
 - в **terraform.tfvars** добавлен параметр private_key_path с указанием пути до приватного ключа ```private_key_path = "~/.ssh/appuser"```
 - в **variables.tf** добавлено
```variable private_key_path {
  description = "Path to the private key used for connection"
}```
- в **main.tf** получаем значение пользовательской переменной
```private_key = file(var.private_key_path)```

Аналогично для переменной Zone.

Форматирование конфигурационных файлов:
```terraform fmt```

Создан файл **terraform.tfvars.example** с переменными.

---------------------------
## Задание со *

Добавлен ssh ключ для нескольких user-ов в метаданные проекта. 
Для этого в файле **main.tf** создана секция resource "google_compute_project_metadata_item" "ssh-keys" с описанием:
```value = "appuser:${file(var.public_key_path)} appuser1:${file(var.public_key_path)} appuser2:${file(var.public_key_path)}"```

Добавлен в веб-интерфейсе в метаданные проекта ключ ssh для юзера appuser_web. 
После выполнения в консоли ```terraform apply```, после чего юзер appuser_web удалился.







