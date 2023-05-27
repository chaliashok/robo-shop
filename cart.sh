#!/usr/bin/env bash
echo -e "\e[34mSeting up source files\e[0m"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> /tmp/robo_shop.log
echo -e "\e[34mDownlaoding nodejs\e[0m"
yum install nodejs -y &>> /tmp/robo_shop.log
echo -e "\e[34madding application user\e[0m"
useradd roboshop &>> /tmp/robo_shop.log

echo -e "\e[34mCreating application code to the directory\e[0m"
mkdir /app &>> /tmp/robo_shop.log
echo -e "\e[34mDOwnlaoding the file\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>> /tmp/robo_shop.log
cd /app
unzip /tmp/cart.zip &>> /tmp/robo_shop.log
echo -e "\e[34mDownloading the dependencies\e[0m"
npm install &>> /tmp/robo_shop.log
echo -e "\e[34mCopying the service file\e[0m"
cp /home/centos/robo-shop/cart.service /etc/systemd/system/cart.service &>> /tmp/robo_shop.log
echo -e "\e[34mLoading the service\e[0m"
systemctl daemon-reload &>> /tmp/robo_shop.log
echo -e "\e[34mstarting the cart\e[0m"
systemctl enable cart &>> /tmp/robo_shop.log
systemctl start cart