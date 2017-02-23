FROM mysql:5.7

ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_ONETIME_PASSWORD
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_DATABASE

COPY initialize.sql .

RUN sed 's/rap_db/'$MYSQL_DATABASE'/g' -i initialize.sql \	
	&& cp initialize.sql /docker-entrypoint-initdb.d/


