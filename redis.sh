#!/bin/bash
source common.sh

echo "Downloading redis remi-release"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_name}
status_check $?
echo -e "\e[32m enabling redis 6.2\e[0m"
yum module enable redis:remi-6.2 -y
status_check $?
echo -e "\e[33mInstalling redis \e[0m"
yum install redis -y &>>${log_name}
status_check $?
echo -e "\e[33mModifying the config files \e[0m"
sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis.conf /etc/redis/redis.conf
status_check $?
services_restart
status_check $?

echo script completed