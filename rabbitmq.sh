#!/bin/bash

echo "Configure YUM Repos from the script provided by vendor."
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> /tmp/robo_shop.log

echo "Configure YUM Repos for RabbitMQ."
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> /tmp/robo_shop.log

echo "Installing rabbitmq"
yum install rabbitmq-server -y &>> /tmp/robo_shop.log

echo "Enabling and Starting RabbitMQ Service"
systemctl enable rabbitmq-server &>> /tmp/robo_shop.log
systemctl start rabbitmq-server  &>> /tmp/robo_shop.log

echo "creating one user for the application."

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

echo "Created User"