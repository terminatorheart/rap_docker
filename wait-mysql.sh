#!/bin/bash

set -e

# host="$1"
# shift
cmd="$@"

until mysql -h $DB_HOST -u $DB_USER -p$DB_PASS ; do
	>&2 echo "mysql is unavailable - sleeping"
	sleep 5
done

>&2 echo "mysql is up -executing command"

# mysqlshow -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME
# 
# if [ $? -ne 0 ];then
# 	# exec mysql -h $DB_HOST -u $DB_USER -p$DB_PASS < init_db.sql
# 	exec mysql -h $DB_HOST -u $DB_USER -p$DB_PASS < ROOT/WEB-INF/classes/database/initialize.sql
# else
# 	echo '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
# fi
	
exec $cmd

# exec mysql -h mysql_db -u rap --password=rap1234 < ROOT/WEB-INF/classes/database/initialize.sql
# exec /bin/bash /opt/tomcat/bin/catalina.sh
