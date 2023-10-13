#!/bin/bash

# git clone -b monolith https://github.com/express42/reddit.git
# cd reddit && bundle install

# # run app
# puma -d

#check app is running
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongod.conf && sudo service mongod restart
