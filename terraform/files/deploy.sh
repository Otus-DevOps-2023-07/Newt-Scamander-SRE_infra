#!/bin/bash

# git clone -b monolith https://github.com/express42/reddit.git
# cd reddit && bundle install

# # run app
# puma -d

#check app is running
sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl daemon-reload
sudo systemctl restart puma
sudo systemctl enable puma
ps aux | grep puma
