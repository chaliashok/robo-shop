source common.sh
app_name="frontend"


echo -e "\e[33mInstalling nginxserver\e[0m"
yum install nginx -y &>> ${log_name}
status_check $?

echo -e "\e[33mDeleting the old app content\e[0m"
rm -rf /usr/share/nginx/html/* &>> ${log_name}
status_check $?

echo -e "\e[33mDownloading the frontend content\e[0m"
curl -o /tmp/${app_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${app_name}.zip &>> ${log_name}
cd /usr/share/nginx/html
unzip /tmp/${app_name}.zip &>> ${log_name}
status_check $?

#need to copy config file
cp /home/centos/robo-shop/roboshop.conf /etc/nginx/default.d/ &>> ${log_name}
echo -e "\e[33mStarting the nginx server\e[0m"
systemctl enable nginx
systemctl restart nginx
status_check $?