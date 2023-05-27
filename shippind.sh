echo Installing maven
yum install maven -y &>> /tmp/robo_shop.log

echo adding application user
useradd roboshop
 echo creating app directory
mkdir /app
echo Downlaoding the application code
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>> /tmp/robo_shop.log

cd /app
unzip /tmp/shipping.zip &>> /tmp/robo_shop.log

echo downlaoding the dependencies
mvn clean package &>> /tmp/robo_shop.log

mv target/shipping-1.0.jar shipping.jar &>> /tmp/robo_shop.log

echo copying the service file
cp /home/centos/robo-shop/shipping.service /etc/systemd/system/shipping.service &>> /tmp/robo_shop.log

echo deamon reload
systemctl daemon-reload &>> /tmp/robo_shop.log


echo enabling and stating shipping
systemctl enable shipping &>> /tmp/robo_shop.log

systemctl start shipping &>> /tmp/robo_shop.log

echo Insatlling mysql
yum install mysql -y &>> /tmp/robo_shop.log

echo Loading the schema
mysql -h mysql-dev.devopsawschinni.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> /tmp/robo_shop.log

echo restarting shipping
systemctl restart shipping &>> /tmp/robo_shop.log

