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

# step 2 - install ruby and git
apt install -y -q git ruby-full ruby-bundler build-essential

# step 3 - clone repo
cd ~/
git clone -b monolith https://github.com/express42/reddit.git

# step 4 - config daemon and startup
cd ~/reddit && bundle install
cat > /etc/systemd/system/puma.service <<EOF
[Unit]
Description=Puma service
After=mongod.service

[Service]
Type=simple
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/reddit
ExecStart=/usr/local/bin/puma
TimeoutSec=300
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl start puma
systemctl enable puma
