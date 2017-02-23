FROM openjdk:7

EXPOSE 8080

ARG TOMCAT_USER=tomcat

ENV TOMCAT_VERSION 8.5.11
ENV RAP_VERSION 0.14.1

RUN mv /etc/apt/sources.list /etc/apt/sources.list_backup \
	&& echo "deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib\ndeb http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib\ndeb-src http://mirrors.aliyun.com/debian/ jessie main non-free contrib\ndeb-src http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y unzip mysql-client

COPY apache-tomcat-${TOMCAT_VERSION}.zip .

RUN unzip apache-tomcat-${TOMCAT_VERSION}.zip \
	&& mv apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

COPY RAP-${RAP_VERSION}-SNAPSHOT.war .

# initial mysql database
RUN unzip RAP-${RAP_VERSION}-SNAPSHOT.war -d ROOT \
	&& sed 's/jdbc.username=root/jdbc.username=rap/' -i ROOT/WEB-INF/classes/config.properties \
	&& sed 's/jdbc.password=/jdbc.password=rap1234/' -i ROOT/WEB-INF/classes/config.properties \
	&& sed 's/\/localhost/\/mysql_db/' -i ROOT/WEB-INF/classes/config.properties \
	&& sed 's/redis.host=localhost/redis.host=redis_db/' -i ROOT/WEB-INF/classes/config.properties \
	&& cat ROOT/WEB-INF/classes/config.properties \
	&& mkdir -p /opt/tomcat/webapps/ \
	&& cp -rf ROOT /opt/tomcat/webapps/ \
	&& groupadd ${TOMCAT_USER} \
	&& useradd -g ${TOMCAT_USER} ${TOMCAT_USER} \
	&& chown -R ${TOMCAT_USER}:${TOMCAT_USER} /opt/tomcat/webapps/ROOT

# RUN mysql -h mysql_db -u rap -p rap1234 -D rap_db < ROOT/WEB-INF/classes/database/initialize.sql

COPY wait-mysql.sh .

RUN chmod +x wait-mysql.sh \
	&& chmod +x /opt/tomcat/bin/catalina.sh

# USER ${TOMCAT_USER}

# CMD ["/opt/tomcat/bin/catalina.sh", "run"]

