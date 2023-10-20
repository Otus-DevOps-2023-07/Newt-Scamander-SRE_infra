#! /bin/bash
#################################################################################
# create auto deploy script for immutable vm with app in yandex cloud by yc cli #
#################################################################################

# step 0 - prepare
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# step 1 - install mongod
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt-get update
apt-get install -y -q mongodb-org
systemctl start mongod
systemctl enable mongod
