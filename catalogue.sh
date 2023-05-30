source common.sh
echo "script started"
export app_name=catalogue
nodejs
mongo_schema_setup
echo "script ended"
