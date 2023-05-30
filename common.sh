log_name="/tmp/robo_shop.log"
app_dir="/app"

status_check(){
  if [ "$1" -eq 0 ];
   then
    echo success
   else echo Failure
   exit 1
  fi
}

user_check() {
id roboshop &>> ${log_name}
if [ $? -eq 1 ]; then
  echo "success"
else
    useradd roboshop &>> ${log_name}
  fi
    }
status_check $?

services_restart()
 {
  echo "Loading the service"
 systemctl daemon-reload &>> ${log_name}
 echo "enabling and starting the service"
 systemctl enable ${app_name} &>> ${log_name}
 systemctl start  ${app_name} &>> ${log_name}
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
user_check
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

mysql_install() {
 echo Installing mysql
    yum install mysql -y &>> ${log_name}
    echo Loading the schema
    mysql -h mysql-dev.devopsawschinni.online -uroot -pRoboShop@1 < /${app_dir}/schema/${app_name}.sql &>> ${log_name}
  }

maven () {
echo Installing maven
yum install maven -y &>> ${log_name}
status_check $?
echo adding application user
user_check
Application_setup
status_check $?
echo downlaoding the dependencies
cd ${app_dir}
mvn clean package &>> ${log_name}
status_check $?
mv target/${app_name}-1.0.jar ${app_name}.jar &>> ${log_name}
status_check $?
echo copying the service file
cp /home/centos/robo-shop/${app_name}.service /etc/systemd/system/${app_name}.service &>> ${log_name}
services_restart
mysql_install
echo restarting shipping
systemctl restart ${app_name} &>> ${log_name}
}

nodejs() {
echo -e "\e[34mSeting up NodeJS repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${log_name}
status_check $?
echo -e "\e[34mInstalling Nodejs\e[0m"
yum install nodejs -y &>> ${log_name}
status_check $?
echo -e "\e[34mAdding Application User\e[0m"
user_check
status_check $?
echo -e "\e[34mSeting up App directory\e[0m"
Application_setup
status_check $?
echo -e "\e[35mDownlaoding the dependencies\e[0m"
npm install &>> ${log_name}
status_check $?
cp /home/centos/robo-shop/${app_name}.service /etc/systemd/system/ &>> ${log_name}
status_check $?
echo -e "\e[35mLoading the service\e[0m"
systemctl daemon-reload &>> ${log_name}
echo -e "\e[35mStarting the service\e[0m"
cp /home/centos/robo-shop/mongo.repo /etc/yum.repos.d/ &>> ${log_name}
status_check $?
echo -e "\e[34minstalling  mongodb-client\e[0m"
yum install mongodb-org-shell -y &>> ${log_name}
status_check $?
echo -e "\e[34mLoading the schema\e[0m"
mongo --host mongodb-dev.devopsawschinni.online </app/schema/${app_name}.js &>> ${log_name}
status_check $?
services_restart
status_check $?
echo -e "\e[34mScript Ended\e[0m"
}

golang() {

echo "Installing golang"
yum install golang -y &>> ${log_name}
status_check $?

echo "Adding User"
user_check
echo "Creating Directory"
rm -rf ${app_dir} &>> ${log_name}
status_check $?
Application_setup
status_check $?
echo "Lets download the dependencies & build the software."
go mod init ${app_name} &>> ${log_name}
go get &>> ${log_name}
go build &>> ${log_name}
status_check $?

echo "Copying the service file"
cp /home/centos/robo-shop/${app_name}.service /etc/systemd/system/${app_name}.service &>> ${log_name}
status_check $?
services_restart

}
