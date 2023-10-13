#! /bin/bash
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install

# run app
puma -d

#check app is running
ps aux | grep puma
