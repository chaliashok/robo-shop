#!/bin/bash
echo "Installing python"
roboshp_user_password=$1
yum install python36 gcc python3-devel -y &>> /tmp/robo_shop.log

echo "Adding user"
useradd roboshop &>> /tmp/robo_shop.log

echo "setting up directory"
rm -rf /app
mkdir /app &>> /tmp/robo_shop.log
echo "Downloading the application code to created app directory"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>> /tmp/robo_shop.log

echo "Downloading the dependencies"
cd /app &>> /tmp/robo_shop.log
unzip /tmp/payment.zip &>> /tmp/robo_shop.log


pip3.6 install -r requirements.txt &>> /tmp/robo_shop.log

echo "Settingup SystemD Payment Servic"
cp /home/centos/robo-shop/payment.service /etc/systemd/system/payment.service &>> /tmp/robo_shop.log
sed -i -e 's/password/${roboshp_user_password}/g' /etc/systemd/system/payment.service &>> /tmp/robo_shop.log
echo "Loading the service"
systemctl daemon-reload &>> /tmp/robo_shop.log

echo "enabling and starting the service"

systemctl enable payment &>> /tmp/robo_shop.log
systemctl start payment &>> /tmp/robo_shop.log
