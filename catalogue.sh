#!/bin/bash
echo "script started"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> /tmp/robo_shop.log

echo "Install Node JS"
yum install nodejs -y &>> /tmp/robo_shop.log

echo "Adding Application user"

useradd roboshop &>> /tmp/robo_shop.log

rm -rf /app
mkdir /app

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>> /tmp/robo_shop.log
cd /app
unzip -o /tmp/catalogue.zip &>> /tmp/robo_shop.log

cd /app
npm install &>> /tmp/robo_shop.log

cp /home/centos/robo-shop/catalogue.service /etc/systemd/system/catalogue.service &>> /tmp/robo_shop.log
systemctl daemon-reload &>> /tmp/robo_shop.log
cp /home/centos/robo-shop/mongo.repo /etc/yum.repos.d/mongo.repo &>> /tmp/robo_shop.log

yum install mongodb-org-shell -y &>> /tmp/robo_shop.log

mongo --host mongodb-dev.devopsawschinni.online </app/schema/catalogue.js &>> /tmp/robo_shop.log


systemctl enable catalogue
systemctl start catalogue

echo "script ended"