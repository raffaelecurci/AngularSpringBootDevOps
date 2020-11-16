#!/bin/bash

# Initialize a mongo data folder and logfile

/bin/su -c "mongod --bind_ip 127.0.0.1 --logpath /var/log/mongodb.log --logappend &" - mongodb

# Wait until mongo logs that it's ready (or timeout after 60s)
COUNTER=0
grep -q 'waiting for connections on port' /var/log/mongodb.log
while [[ $? -ne 0 && $COUNTER -lt 60 ]] ; do
    sleep 2
    let COUNTER+=2
    echo "Waiting for mongo to initialize... ($COUNTER seconds so far)"
    grep -q 'Waiting for connections' /var/log/mongodb.log
done

echo "use Employee" > init.js
echo "db.createUser({	user: \"Employeeadmin\", pwd: \"password\",	roles:[{role: \"userAdmin\" , db:\"Employee\"}]})" >> init.js

#Initialize mongodb, create db and user
/bin/su -c "mongo < init.js" - mongodb

#Launch Spring application
/bin/su -c "java -jar /home/spring/application.jar >> ~/application.log" - spring
