#!/bin/bash
echo "Installing python"
source common.sh
roboshp_user_password=$1


if [ -z "$roboshp_user_password" ]; then
  echo "roboshp_user_password is missing"
  exit 1
fi
app_name="payment"

python
echo process has been completed