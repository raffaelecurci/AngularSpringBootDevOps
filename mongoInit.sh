#!/bin/bash

# Initialize a mongo data folder and logfile

/bin/su -c "cd; pwd ; /usr/bin/mongod --bind_ip 127.0.0.1 --fork --logpath /var/log/mongodb.log --logappend &" - mongodb

# Wait until mongo logs that it's ready (or timeout after 60s)
COUNTER=0
grep -q 'waiting for connections on port' /var/log/mongodb.log
while [[ $? -ne 0 && $COUNTER -lt 60 ]] ; do
    sleep 2
    let COUNTER+=2
    echo "Waiting for mongo to initialize... ($COUNTER seconds so far)"
    grep -q 'Waiting for connections' /var/log/mongodb.log
done

echo "use Employee" > /home/mongodb/init.js
echo "db.createUser({	user: \"Employeeadmin\", pwd: \"password\", mechanisms:[\"SCRAM-SHA-1\"], roles:[{role: \"userAdmin\" , db:\"Employee\"}]})" >> /home/mongodb/init.js

#Initialize mongodb, create db and user
/bin/su -c "mongo < /home/mongodb/init.js" - mongodb

#Launch Spring application
/bin/su -c "cd ; pwd ; java -jar /home/spring/application.jar " - spring
#>> ~/application.log &
