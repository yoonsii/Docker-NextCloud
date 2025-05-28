#!/bin/bash

read -p "Would you like to stop all containers first? (y/n) " STOPCONTAINER

echo ${STOPCONTAINER}

if [ $STOPCONTAINER == "y" ]; then
	docker stop $(docker ps -a -q)
	docker container prune
fi

docker volume rm nextcloud-mysql-data

#docker run -d \
#  --network nextcloud-app \
#  --network-alias mysql \
#  -v nextcloud-mysql-data:/var/lib/mysql \
#  -v $(pwd)/init-user.sql:/docker-entrypoint-initdb.d/init-user.sql \
#  -e MYSQL_ROOT_PASSWORD=secret \
#  -e MYSQL_DATABASE=nextcloud \
#  mysql:8.0   
#
docker run -d   --network nextcloud-app   --network-alias mysql   -v nextcloud-mysql-data:/var/lib/mysql   -v $(pwd)/init-user.sql:/docker-entrypoint-initdb.d/init-user.sql   -e MYSQL_ROOT_PASSWORD=secret   -e MYSQL_DATABASE=nextcloud   mysql:8.0

sleep 60

 

docker run -e DB_PASS=nextcloudpass -dp 8080:80 --network nextcloud-app yoonsi/docker-nextcloud:dev 



 
