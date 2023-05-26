echo -e "\e34mInstalling nginxserver\e[0m"
yum install nginx -y

echo -e "\e34mDeleting the old app content\e[0m"
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

cd /usr/share/nginx/html
unzip /tmp/frontend.zip

#need to copy config file

systemctl enable nginx
systemctl restart nginx