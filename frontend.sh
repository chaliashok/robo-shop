source common.sh
app_name="frontend"


echo "Installing nginxserver"
yum install nginx -y &>> ${log_name}
status_check $?

echo "Deleting the old app content"
rm -rf /usr/share/nginx/html/* &>> ${log_name}
status_check $?

echo "Downloading the frontend content"
curl -o /tmp/${app_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${app_name}.zip &>> ${log_name}
cd /usr/share/nginx/html
unzip /tmp/${app_name}.zip &>> ${log_name}
status_check $?

#need to copy config file
cp /home/centos/robo-shop/roboshop.conf /etc/nginx/default.d/ &>> ${log_name}
echo "Starting the nginx server"
systemctl enable nginx
systemctl restart nginx
status_check $?