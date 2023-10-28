#! /bin/bash
#################################################################################
# create auto deploy script for immutable vm with app in yandex cloud by yc cli #
#################################################################################

# step 0 - prepare
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections


# step 1 - install ruby and git
apt-get update && apt-get install -y -q git
apt-get install -y -q ruby-full ruby-bundler build-essential

# step 2 - clone repo
cd ~/
git clone -b monolith https://github.com/express42/reddit.git

# step 3 - config daemon and startup
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
