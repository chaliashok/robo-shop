#!/bin/bash

echo -e "\e[34mSeting up NodeJS repos\e[0m"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> /tmp/robo_shop.log

echo -e "\e[34mInstalling Nodejs\e[0m"

yum install nodejs -y &>> /tmp/robo_shop.log

echo -e "\e[34mAdding Application User\e[0m"
useradd roboshop &>> /tmp/robo_shop.log

echo -e "\e[34mSeting up App directory\e[0m"
mkdir /app &>> /tmp/robo_shop.log

echo -e "\e[34mDownloading the application code to created app directory.\e[0m"

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>> /tmp/robo_shop.log
cd /app
unzip -o /tmp/user.zip &>> /tmp/robo_shop.log

echo -e "\e[35mDownlaoding the dependencies\e[0m"

npm install &>> /tmp/robo_shop.log

cp /home/centos/robo-shop/user.service /etc/systemd/system/ &>> /tmp/robo_shop.log

echo -e "\e[35mLoading the service\e[0m"
systemctl daemon-reload &>> /tmp/robo_shop.log

echo -e "\e[35mStarting the service\e[0m"


cp /home/centos/robo-shop/mongo.repo /etc/yum.repos.d/ &>> /tmp/robo_shop.log

echo -e "\e[34minstalling  mongodb-client\e[0m"
yum install mongodb-org-shell -y &>> /tmp/robo_shop.log

echo -e "\e[34mLoading the schema\e[0m"
mongo --host mongodb-dev.devopsawschinni.online </app/schema/user.js &>> /tmp/robo_shop.log

echo -e "\e[34mStarting the service\e[0m"

systemctl enable user
systemctl start user

echo -e "\e[34mScript Ended\e[0m"


