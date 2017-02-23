#!/bin/bash

set -e

# exec mysql -h mysql_db -u rap --password=rap1234 -D rap_db < ROOT/WEB-INF/classes/database/initialize.sql
# host="$1"
# shift
cmd="$@"

echo '0000000000000000000000000000000000000'
echo $DB_USER
echo $DB_PORT
echo $DB_NAME
echo '0000000000000000000000000000000000000'

until mysql -h $DB_HOST -u $DB_USER --password=$DB_PASS ; do
	>&2 echo "mysql is unavailable - sleeping"
	sleep 5
done

>&2 echo "mysql is up -executing command"

if [ $(mysqlshow -h $DB_HOST -u $DB_USER --password=$DB_PASS $DB_NAME) -ne 0 ];then
	exec mysql -h $DB_HOST -u $DB_USER --password=$DB_PASS < ROOT/WEB-INF/classes/database/initialize.sql
fi
	
exec $cmd

# exec mysql -h mysql_db -u rap --password=rap1234 < ROOT/WEB-INF/classes/database/initialize.sql
# exec /bin/bash /opt/tomcat/bin/catalina.sh
