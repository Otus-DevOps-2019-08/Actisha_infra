
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
 
variable private_key_path {
  description = "Path to the private key used for connection"
}

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

#### #HW7 Terraform 2

Создана ветка terraform-2, создана инфраструктура по шаблонам из HW6 в директории terraform (```terraform apply```).
Проверено дефолтное правило для ssh:
```gcloud compute firewall-rules list```

В **main.tf** создан ресурс firewall resource "google_compute_firewall" "firewall_ssh" с описанием:
``` 
   name = "default-allow-ssh"   network = "default" 
   allow {     protocol = "tcp"     ports = ["22"]   } 
   source_ranges = ["0.0.0.0/0"] }
```

Выполнено ```terraform apply```, соответственно, возникла ошибка, т.к. terraform не знает, что данное правило firewall уже существует. 
Для того, чтобы ее избежать необходимо импортировать информацию о созданных без помощи terraform ресурсах.
```terraform import google_compute_firewall.firewall_ssh default-allow-ssh```
Снова выполнено ```terraform apply```. Теперь всё отработало корректно.

В **main.tf** добавлен ресурс google_compute_address (используется для определения IP-адреса).
*В случае, если после добавления этого ресурса на следующем шаге падает терраформ с ошибкой Quota 'STATIC_ADDRESSES' exceeded, необходимо зайти в VPC Network -> external ip addresses и удалить static ip, который был зарезервирован под инстанс бастиона.

Удалена и создана заново инфраструктура.

*Ссылку в одном ресурсе на атрибуты другого тераформ понимает как зависимость одного ресурса от другого. Это влияет на очередность создания и удаления ресурсов при применении изменений.

Соответственно, в ресурсе "google_compute_instance" был определен IP-адрес для создаваемого инстанса (это не явная зависимость):
```
network_interface {
 network = "default"
 access_config { nat_ip = google_compute_address.app_ip.address } 
 }
```

Также Terraform поддерживает также явную зависимость используя параметр ```depends_on```:
https://www.terraform.io/docs/configuration/resources.html

--------------------------- 
##Структуризация ресурсов

БД вынесена на отдельный инстанс VM. 
Для этого в директории packer, были созданы шаблоны **db.json**(с установкой Mongodb) и **app.json** (с установкой Ruby).

Провалидировали файлы:
```
packer -var-file variables.json validate app.json
packer -var-file variables.json validate db.json
```

Запекли образы:
```
packer build -var-file variables.json app.json
packer build -var-file variables.json db.json
```

В директории terrafor конфиг **main.tf** разбит на три:
**app.tf**(приложение),
**db.tf**(БД),
**vpc.tf**(firewall rules для ssh).

В **variables.tf** добавлено описание переменных image-ей для БД и APP:
```
variable app_disk_image {   description = "Disk image for reddit app"   default = "reddit-app-base" }
```
```
variable db_disk_image {   description = "Disk image for reddit db"   default = "reddit-db-base" }
```

В **vpc.tf** выносим правило firewall_ssh:
```
resource "google_compute_firewall" "firewall_ssh" {   
name = "default-allow-ssh"   network = "default"   
allow {    
 protocol = "tcp"     
 ports = ["22"]   
 }   
source_ranges = ["0.0.0.0/0"] 
}
```
 
в **main.tf** осталось:
```
provider "google" 
{  
version = "~> 2.15"   
project = var.project   
region = var.region 
}
```
 
Выполнено:
```
terraform fmt
terraform plan
terraform apply
``` 

Результат: всё успешно созадлось. 

--------------------------- 
##Модули

В директории terraform создана директория *modules->db*. В неё перенесены файлы **main.tf**, **variables.tf**, **outputs.tf**.
В **variables.tf**:
```
variable public_key_path {   description = "Path to the public key used to connect to instance" } 
variable zone {   description = "Zone" } 
variable db_disk_image {   description = "Disk image for reddit db"   default     = "reddit-db-base" }
```
В директории terraform создана директория *modules->app*. В неё перенесены файлы **main.tf**, **variables.tf**, **outputs.tf**.
В **variables.tf**:
```
variable public_key_path {   description = "Path to the public key used to connect to instance" } 
variable zone {   description = "Zone" } 
variable app_disk_image {   description = "Disk image for reddit app"   default     = "reddit-app-base" }
```
В **outputs.tf**:
```
output "app_external_ip" {   value = google_compute_instance.app.network_interface.0.access_config.0.assigned_nat_ip }
```

В директории terraform удалены **db.tf** и **app.tf**. 
Скорректирован файл **main.tf**:
```
  provider "google" {
  version = "~> 2.15"
  project = var.project
  region  = var.region
}
module "app" {
  source          = "./modules/app"
  project         = var.project
  public_key_path = var.public_key_path
  zone            = var.zone
  app_disk_image  = var.app_disk_image
}
module "db" {
  source          = "./modules/db"
  project         = var.project
  public_key_path = var.public_key_path
  zone            = var.zone
  db_disk_image   = var.db_disk_image
}
```

Для использования модулей они были загружены в *.terraform* командой ```terraform get```.
Выполнена команда ```terraform plan```.
Если возникнет ошибка  *output 'app_external_ip': unknown resource 'google_compute_instance.app'*, то необходимо переопределить переменную.
```
output "app_external_ip" {   value = module.app.app_external_ip }
```
Повторно выполнена команда ```terraform plan```.

Аналогично предыдущим модулям создан модуль vpc, в котором определены настройки firewall_ssh:
Cоздана директория *terraform->modules->vpc*. 
В неё перенесены файлы **main.tf**, **variables.tf**, **outputs.tf**.
Описан вызов модуля в основном конфиге main.tf:
```
  module "vpc" {
  source          = "./modules/vpc"
  project         = var.project
  public_key_path = var.public_key_path
  zone            = var.zone
}
```
В директории terraform удален **vpc.tf**. 
Выполнены команды: 
```terraform get```
```terraform apply```

Результат - в GCP появилось правило фаерволла для ssh, к обоим инстансам можно подключиться по ssh.

--------------------------- 
### Параметризация модулей
В **vpc.tf** параметрезирован модуль за счёт использования input переменных.
В **main.tf** в ресурс ```resource "google_compute_firewall" "firewall_ssh"```добавлено описание:
```source_ranges = var.source_ranges```
В **variables.tf** добавлено описание IP-адресов, с которых возможен доступ.
```
variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}
```

Проведен эксперимент, в блоке, описывающем подключение модуля vpc, добавлено правило, позволяющее доступ только с моего IP:
```source_ranges = ["my_ip/32"]```
Доступ был разрешен только с моего IP. 
Возвращено значение 0.0.0.0/0 в source_ranges.

Ресурсы были удалены:
```terraform destroy``` 
  
--------------------------- 
## Создание Stage & Prod
В директории terraform создана директории *modules->stage* и *modules->prod*.
Из директории terraform в них скопированы файлы: **main.tf**,**terraform.tfvars**, **variables.tf**, **outputs.tf**.  

В **main.tf** для *stage* открыт ssh доступ для всех IP-адресов:
```
  module "vpc" {
  source          = "../modules/vpc"
  project         = var.project
  public_key_path = var.public_key_path
  source_ranges   = ["0.0.0.0/0"]
}
```

В **main.tf** для *prod* открыт ssh доступ для конкретного IP-адреса:
```
  module "vpc" {
  source          = "../modules/vpc"
  project         = var.project
  public_key_path = var.public_key_path
  source_ranges   = ["94.25.168.212/32"]
}
```
Также в **main.tf** были скорректированы пути ко всем модулям "../modules/app" и др.

Выполнена проверка правильности настроек конфигурации для каждого окружения:
выполнено получение модулей ```terraform get```,
произведена инициализация ```terraform init```,
применены изменения ```terraform apply```,
удалены созданные ресурсы ```terraform destroy```.

--------------------------- 
## Самостоятельное задание
Удалены файлы **main.tf**,**terraform.tfvars**, **variables.tf**, **outputs.tf** из директории terraform. 
Выполнена частичная параметризация конфигурации модулей.
Отформатированы конфигурационные файлы ```terraform fmt```.

--------------------------- 
## Реестр модулей
Ссылка на публичный реестр модулей от HashiCorp - https://registry.terraform.io/
Для создания бакета в сервисе Storage использован модуль *storage-bucket* - https://registry.terraform.io/modules/SweetOps/storage-bucket/google/0.3.0
В директории terraform был созадн файл **storage-bucket.tf**.
Затем туда же были скопированы файлы **variables.tf** и **terraform.tfvars**. 
Выполнено проверка и применени. 
```terraform fmt```
```terraform get```
```terraform init```
```terraform plan```
```terraform apply```
Проверено в GSP - созадлся Storage - https://console.cloud.google.com/storage/browser/sweetops-storage-hanna / gs://sweetops-storage-hanna

--------------------------- 
## Задание*
В каталогах stage и prod создан файл **backend.tf**.
в каждом каталоге выполнена команда ```terraform init```.
Конфиги были вынесены в другую директорию, по очереди в каждом каталоге запущен Terraform.
При запуске конфигурации одновременно срабатывают блокировки.

#### #HW8 Ansible 1

Выполнена установка/проверка наличия:
Python 2.7.5
pip 19.3.1 from /usr/lib/python2.7/site-packages/pip (python 2.7)
ansible 2.9.4 (с помощью предварительно созданного файла **requirements.txt** - ```pip install -r requirements.txt```)

--------------------------- 
##Управление хостом при помощи Ansible 
Создана инфраструктура из окружения *stage* -  ```terraform apply```.
В директории *ansible* создан файл **inventory**.
```appserver ansible_host=@my_ip@ ansible_user=appuser ansible_private_key_file=~/.ssh/appuser```

Запускаем проверку, что ansible имеет доступ к нашей инфраструктуре в части app:
```ansible appserver -i ./inventory -m ping```
Вывод:
```
  appserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```

```-m ping``` - вызываемый модуль 
```-i ./inventory``` - путь до файла инвентори 
```appserver``` - Имя хоста, которое указали в инвентори, откуда Ansible yзнает, как подключаться к хосту.

Аналогично проделано для инстанса с БД.
```dbserver ansible_host=35.233.123.223 ansible_user=appuser ansible_private_key_file=~/.ssh/appuser```
Запускаем проверку, что ansible имеет доступ к нашей инфраструктуре в части db:
```ansible dbserver -i ./inventory -m ping```
Вывод:
```
dbserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```

Создан конфиг **ansible.cfg** в директории *ansible*.
```
inventory = ./inventory 
remote_user = appuser 
private_key_file = ~/.ssh/appuser 
host_key_checking = False retry_files_enabled = False
```

Скорретирован **inventory**:
```
$ cat inventory
appserver ansible_host=35.195.74.19
dbserver ansible_host=35.233.123.223
```

Для проверки выполнено:
```ansible dbserver -m command -a uptime```
Модуль *command* позволяет запускать произвольные команды на удаленном хосте.
Команда *uptime* показывает время работы инстанса. 
Команд *uptime* передается как аргумент для данного модуля, с помощью опции *-a*.

Вывод:
```
dbserver | CHANGED | rc=0 
 13:01:22 up  1:56,  1 user,  load average: 0.07, 0.02, 0.00
 ```
 
--------------------------- 
##Работа с группами хостов

Скорректировала **inventory** файл для упрощения работы с группами хостов:
```
[app]
appserver ansible_host=35.195.74.19
[db]
dbserver ansible_host=35.233.123.223
```
Проверяем результат ```ansible app -m ping```:

```
  appserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```

*app* - имя группы, 
*-m ping* - имя модуля Ansible, 
*appserver* - имя сервера в группе, для которого применился модуль.

--------------------------- 
##Создание inventory.yml

```
app:
  hosts:
    appserver:
      ansible_host: 35.195.74.19

db:
  hosts:
    dbserver:
      ansible_host: 35.233.123.223 
```

Проверяем корректность ```ansible all -m ping -i inventory.yml```:

```
appserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```

```
dbserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```

Ключ -i переопределяет путь к инвентори файлу.

--------------------------- 
##Выполнение команд через ansible

Проверка версии Ruby на app-сервере через ansible ```ansible app -m command -a 'ruby -v'```:
```
appserver | CHANGED | rc=0 >>
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
```

Проверка bundler на app-сервере через ansible```ansible app -m command -a 'bundler -v'```:
```
appserver | CHANGED | rc=0 >>
Bundler version 1.11.2
```

Проверка запуска двух команд через модуль command:
```ansible app -m command -a 'ruby -v; bundler -v'```

```
appserver | FAILED | rc=1 >>
ruby: invalid option -;  (-h will show valid options) (RuntimeError)non-zero return code
```

Завершилось с ошибкой, т.к. модуль *command* выполняет команды, не используя оболочку (sh, bash), поэтому в нем не работают перенаправления потоков и нет доступа к некоторым переменным окружения.

Проверка выполнения через модуль *shell* ```ansible app -m shell -a 'ruby -v; bundler -v'```:
```
appserver | CHANGED | rc=0 >>
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
Bundler version 1.11.2
```

Проверка на хосте с БД статус сервиса MongoDB с помощью модуля command или shell(эта операция аналогична запуску на хосте команды systemctl status mongod).```ansible db -m command -a 'systemctl status mongod'```:

```
dbserver | CHANGED | rc=0 >>
● mongod.service - High-performance, schema-free document-oriented database
```
Через модуль *shell* ```ansible db -m shell -a 'systemctl status mongod'```:
```
dbserver | CHANGED | rc=0 >>
● mongod.service - High-performance, schema-free document-oriented database
```

И еще разочек, но с помощью модуля *systemd*, который предназначен для управления сервисами ```ansible db -m systemd -a name=mongod```:
```
dbserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "name": "mongod",
    "status": {
...
        "ActiveState": "active"
```
И совсем последний разочек с помощью модуля *service*, который более универсален и будет работать и в более старых ОС с init.d инициализацией
 ```ansible db -m service -a name=mongod```:

```
dbserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "name": "mongod",
    "status": {
...
        "ActiveState": "active"
```
Используем модуль *git* для клонирования репозитория на app-сервер ```ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/appuser/reddit'```:

```
appserver | CHANGED => {
    "after": "5c217c565c1122c5343dc0514c116ae816c17ca2",
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "before": null,
    "changed": true
}
```

Повторно выполняем команду:

```
appserver | SUCCESS => {
    "after": "5c217c565c1122c5343dc0514c116ae816c17ca2",
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "before": "5c217c565c1122c5343dc0514c116ae816c17ca2",
    "changed": false,
    "remote_url_changed": false
}
```

Разница в значениях переменных (это значит, что изменения не произошли). Само выполнение повторное команды проходит успешно.
   * "before": null,
   * "changed": true
 и при втором выполнении эти параметры уже стали:
   * "before": "5c217c565c1122c5343dc0514c116ae816c17ca2",
   * "changed": false,
   * "remote_url_changed": false
   
Аналогично выполним с модулем *command* ```ansible app -m command -a 'git clone https://github.com/express42/reddit.git /home/appuser/reddit'```:

Повторное выполнение завершается с ошибкой.
```
appserver | FAILED | rc=128 >>
fatal: destination path '/home/appuser/reddit' already exists and is not an empty directory.non-zero return code
```

--------------------------- 
##Создание простого playbook для ansible
Созан файл **clone.yml**, выполняющий клонирование репозитория аналогично предыдущим командам:
```
- name: Clone
  hosts: app
  tasks:
    - name: Clone repo
      git:
        repo: https://github.com/express42/reddit.git
        dest: /home/appuser/reddit
```

Выполнена команда ```ansible-playbook clone.yml```:
PLAY RECAP ********************************************************************************************************************
appserver                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

Выполнено удаление каталога с репозиторием  ```ansible app -m command -a 'rm -rf ~/reddit'```:
```
appserver | CHANGED | rc=0 >>
```

Повторно выполнен playbook, клонирующий репозиторий:
PLAY RECAP ********************************************************************************************************************
appserver                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

Как видим, выполнилось одно изменени. 





















