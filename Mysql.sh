#!/usr/bin/env bash
source common.sh
password=$1
app_name="mysqld"
echo script started
yum module disable mysql -y &>> ${log_name}
status_check $?
echo installing Mysql community server
cp /home/centos/robo-shop/mysql.repo /etc/yum.repos.d/mysql.repo
status_check $?
yum install mysql-community-server -y &>> ${log_name}
status_check $?
echo enabling and satrting mysqld
services_restart
status_check $?
echo secure client installation
mysql_secure_installation --set-root-pass ${password} &>> ${log_name}
status_check $?
#mysql -uroot -pRoboShop@1 &>> ${log_name}


