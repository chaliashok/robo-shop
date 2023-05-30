#!/bin/bash
source common.sh
echo "script started"
echo -e "\e[33mstarted\e[0m"
cp /home/centos/robo-shop/mongo.repo /etc/yum.repos.d/ &>> ${log_name}
status_check $?
echo -e "\e[33mInstalling MongoDB\e[0m"
yum install mongodb-org -y >> ${log_name}
status_check $?
systemctl enable mongod >> ${log_name}
systemctl start mongod >> ${log_name}
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf >> ${log_name}
status_check $?
systemctl restart mongod
echo "Process completed"