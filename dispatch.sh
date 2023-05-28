#!/bin/bash

echo "Installing golang"
yum install golang -y &>> /tmp/robo_shop.log

echo "Adding User"
useradd roboshop &>> /tmp/robo_shop.log
echo "Creating Directory"
mkdir /app &>> /tmp/robo_shop.log

echo "Downloading the depedencies"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>> /tmp/robo_shop.log
cd /app &>> /tmp/robo_shop.log
unzip /tmp/dispatch.zip &>> /tmp/robo_shop.log

echo "Lets download the dependencies & build the software."
go mod init dispatch &>> /tmp/robo_shop.log
go get &>> /tmp/robo_shop.log
go build &>> /tmp/robo_shop.log

echo "Copying the service file"
cp /home/centos/robo-shop/dispatch.service /etc/systemd/system/dispatch.service &>> /tmp/robo_shop.log

echo "Reloading the service"
systemctl daemon-reload &>> /tmp/robo_shop.log

echo "Enabling and starting the service"
systemctl enable dispatch &>> /tmp/robo_shop.log
systemctl start dispatch &>> /tmp/robo_shop.log
