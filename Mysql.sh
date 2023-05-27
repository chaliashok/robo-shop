#!/usr/bin/env bash
echo script started
yum module disable mysql -y &>> /tmp/robo_shop.log
echo installing Mysql community server

cp /home/centos/robo_shop/mysql.repo /etc/yum.repos.d/mysql.repo
yum install mysql-community-server -y &>> /tmp/robo_shop.log
echo enabling and satrting mysqld
systemctl enable mysqld
systemctl start mysqld
echo secure client installation
mysql_secure_installation --set-root-pass RoboShop@1 &>> /tmp/robo_shop.log
mysql -uroot -pRoboShop@1 &>> /tmp/robo_shop.log


