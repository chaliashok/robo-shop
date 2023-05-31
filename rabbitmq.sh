#!/bin/bash
source common.sh
app_name=rabbitmq-service

echo "Configure YUM Repos from the script provided by vendor."
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> ${log_name}

echo "Configure YUM Repos for RabbitMQ."
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> ${log_name}
status_check $?

echo "Installing rabbitmq"
yum install rabbitmq-server -y &>> ${log_name}
status_check $?

echo "Enabling and Starting RabbitMQ Service"
services_restart
status_check $?

echo "creating one user for the application."

rabbitmqctl add_user roboshop $1 &>> ${log_name}
status_check $?
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> ${log_name}
status_check $?

echo "Created User"