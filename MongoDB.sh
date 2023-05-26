#!/bin/bash
echo "script started"
echo -e "\e[33mstarted\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>> /tmp/robo_shop.log
echo -e "\e[33mInstalling MongoDB\e[0m"
yum install mongodb-org -y >> /tmp/robo_shop.log
systemctl enable mongod >> /tmp/robo_shop.log
systemctl start mongod >> /tmp/robo_shop.log
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf >> /tmp/robo_shop.log
systemctl restart mongod
echo -e "\e[restart mongodb\e[0m"