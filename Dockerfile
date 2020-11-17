FROM mongo

RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
RUN mkhomedir_helper mongodb
RUN chsh --shell /bin/bash mongodb
#RUN userdel --remove mongodb
#RUN useradd -ms /bin/bash mongodb
RUN mkdir -p /data/log
RUN touch /var/log/mongodb.log
RUN touch /home/mongodb/.dbshell
RUN chown -R mongodb:mongodb /data
RUN chown -R mongodb:mongodb /home/mongodb
RUN chown -R mongodb:mongodb /var/log/mongodb.*
RUN chmod 664 /var/log/mongodb.*
RUN useradd -ms /bin/bash spring
COPY backend/target/*.jar /home/spring/application.jar
RUN chown spring:spring /home/spring/application.jar
COPY mongoInit.sh mongoInit.sh

RUN chmod +x mongoInit.sh
RUN chown mongodb:mongodb mongoInit.sh

RUN touch /home/mongodb/init.js
RUN chown mongodb:mongodb /home/mongodb/init.js

EXPOSE 27017
EXPOSE 8080
#USER root:root
#CMD ["mongod","--bind_ip_all","--fork","--logpath","/var/log/mongodb.log", "&&", "java","-jar","/home/spring/application.jar"]
#ENTRYPOINT ["/bin/sh"]
CMD ./mongoInit.sh
