echo -e "\e[33mInstalling nginxserver\e[0m"
yum install nginx -y &>> /tmp/robo_shop.log

echo -e "\e[33mDeleting the old app content\e[0m"
rm -rf /usr/share/nginx/html/* &>> /tmp/robo_shop.log

echo -e "\e[33mDownloading the frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>> /tmp/robo_shop.log
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> /tmp/robo_shop.log

#need to copy config file
cp /home/centos/robo-shop/roboshop.conf /etc/nginx/default.d/ &>> /tmp/robo_shop.log
echo -e "\e[33mStarting the nginx server\e[0m"
systemctl enable nginx
systemctl restart nginx