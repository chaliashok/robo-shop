#!/bin/bash
echo "script started"
echo -e "\e[33mstarted\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[33mInstalling MongoDB\e[0m"
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod
sed -i 's/127.0.0.1/0.0.0.0' /etc/mongod.conf
systemctl restart mongod
echo -e "\e[restart mongodb\e[0m"