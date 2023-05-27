#!/bin/bash
echo "Downloading redis remi-release"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>/tmp/roboshop.log
echo -e "\e[32m enabling redis 6.2\e[0m"
yum module enable redis:remi-6.2 -y
echo -e "\e[33mInstalling redis \e[0m"
yum install redis -y &>/tmp/roboshop.log
echo -e "\e[33mModifying the config files \e[0m"
sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis.conf /etc/redis/redis.conf
echo -e "\e[34mStarting redis \e[0m"
systemctl enable redis
systemctl start redis
mail -s "redis installation completed" chali.ashok@gmail.com<<<"Successfully completed"
echo script completed