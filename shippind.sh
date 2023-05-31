echo Process started
source common.sh
app_name=shipping

mysql_password=$1

if [ -z "$mysql_password" ]; then
  echo "mysql_password is missing"
  exit 1
fi
maven

echo Process completed


