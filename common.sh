log_name="/tmp/robo_shop.log"
app_dir="/app"

status_check(){
  if [ "$1" -eq 0 ];
   then
    echo success
   else echo Failure
  fi
}
services_restart()
 {
  echo "Loading the service"
 systemctl daemon-reload &>> ${log_name}

 echo "enabling and starting the service"

 systemctl enable ${app_name} &>> ${log_name}
 systemctl start ${app_name} &>> ${log_name}
 }


  Application_setup()
 { echo "setting up directory"
  rm -rf ${app_dir}
  mkdir ${app_dir} &>> ${log_name}
  echo "Downloading the application code to created app directory"
  curl -L -o /tmp/${app_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${app_name}.zip &>> ${log_name}

  echo "Downloading the dependencies"
  cd ${app_dir} &>> ${log_name}
  unzip /tmp/${app_name}.zip &>> ${log_name}
  }
python (){

yum install python36 gcc python3-devel -y &>> ${log_name}
status_check $?

echo "Adding user"
user_check(){
id roboshop &>> ${log_name}
status_check $?

if [ "$1" -eq 1 ]; then
  echo "success"
  else
    useradd roboshop &>> ${log_name}
  fi
    }
    user_check $?

Application_setup
status_check $?
pip3.6 install -r requirements.txt &>> ${log_name}
status_check $?
echo "Settingup SystemD ${app_name} Servic"
cp /home/centos/robo-shop/${app_name}.service /etc/systemd/system/${app_name}.service &>> ${log_name}
status_check $?
sed -i -e "s/password/${roboshp_user_password}/g" /etc/systemd/system/${app_name}.service &>> ${log_name}
status_check $?
services_restart
status_check $?
}

maven () {

  app_directory() {
     echo creating app directory
    mkdir ${app_dir}
    status_check $?
    echo Downlaoding the application code
    curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>> ${log_name}
    status_check $?
    cd ${app_dir}
    unzip /tmp/shipping.zip &>> ${log_name}
  }

  mysql_install() {

    echo Installing mysql
    yum install mysql -y &>> ${log_name}

    echo Loading the schema
    mysql -h mysql-dev.devopsawschinni.online -uroot -pRoboShop@1 < ${app_dir}/schema/shipping.sql &>> ${log_name}
  }

echo Installing maven
yum install maven -y &>> ${log_name}
status_check $?

echo adding application user

user_check(){
id roboshop &>> ${log_name}
status_check $?

if [ "$1" -eq 1 ]; then
  echo "success"
  else
    useradd roboshop &>> ${log_name}
  fi
    }
    user_check $

app_directory
status_check $?

echo downlaoding the dependencies
mvn clean package &>> ${log_name}
status_check $?

mv target/shipping-1.0.jar shipping.jar &>> ${log_name}
status_check $?

echo copying the service file
cp /home/centos/robo-shop/shipping.service /etc/systemd/system/shipping.service &>> ${log_name}

echo deamon reload
systemctl daemon-reload &>> ${log_name}


echo enabling and stating shipping

systemctl enable shipping &>> ${log_name}
systemctl start shipping &>> ${log_name}

mysql_install

echo restarting shipping
systemctl restart shipping &>> ${log_name}

}

