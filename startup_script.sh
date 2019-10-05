#!/bin/bash

cd /home/appuser

#install_ruby.sh
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential

#install_mongodb.sh
udo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb [trusted=yes] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt update
sudo apt install -y mongodb-org

sudo systemctl enable mongod
sudo systemctl start mongod

#deploy.sh
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d

