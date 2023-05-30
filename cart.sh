#!/usr/bin/env bash
source common.sh
app_name="cart"

echo -e "\e[34mSeting up source files\e[0m"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${log_name}
status_check $?
echo -e "\e[34mDownlaoding nodejs\e[0m"
yum install nodejs -y &>> ${log_name}
status_check $?
echo -e "\e[34madding application user\e[0m"
user_check
status_check $?

Application_setup
status_check $?

echo -e "\e[34mDownloading the dependencies\e[0m"
npm install &>> ${log_name}
status_check $?
echo -e "\e[34mCopying the service file\e[0m"
cp /home/centos/robo-shop/${app_name}.service /etc/systemd/system/${app_name}.service &>> ${log_name}
status_check $?

services_restart
status_check $?
echo Script ended
