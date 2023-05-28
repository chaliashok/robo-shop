#!/bin/bash

log_name="/tmp/robo_shop.log"
app_name="dispatch"
app_dir="/app"

echo "Installing golang"
yum install golang -y &>> ${log_name}

echo "Adding User"
useradd roboshop &>> ${log_name}
echo "Creating Directory"
mkdir ${app_dir} &>> ${log_name}

echo "Downloading the depedencies"
curl -L -o /tmp/${app_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${app_name}.zip &>> ${log_name}
cd ${app_dir} &>> ${log_name}
unzip /tmp/${app_name}.zip &>> ${log_name}

echo "Lets download the dependencies & build the software."
go mod init ${app_name} &>> ${log_name}
go get &>> ${log_name}
go build &>> ${log_name}

echo "Copying the service file"
cp /home/centos/robo-shop/${app_name}.service /etc/systemd/system/${app_name}.service &>> ${log_name}

echo "Reloading the service"
systemctl daemon-reload &>> ${log_name}

echo "Enabling and starting the service"
systemctl enable ${app_name} &>> ${log_name}
systemctl start ${app_name} &>> ${log_name}
