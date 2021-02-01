## Use to run mysql db docker image
docker run --name mysqldb -p 3307:3306 -e MYSQL_DATABASE=pageviewservice -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:5.7

## Use to run RabbitMQ
docker run --name rabbitmq -p 5671:5671 -p 5672:5672 -d rabbitmq

## does not work
#docker run --name pageviewservice -p 8081:8081  springframeworkguru/pageviewservice

## does not work
#docker run --name pageviewservice -p 8081:8081 -e SPRING_DATASOURCE_URL=jdbc:mysql://127.0.0.1:3306/pageviewservice -e SPRING_PROFILES_ACTIVE=mysql springframeworkguru/pageviewservice

docker run --name pageviewservice -p 8081:8081 -d \
--link rabbitmq:rabbitmq \
--link mysqldb:mysqldb \
-e SPRING_DATASOURCE_URL=jdbc:mysql://mysqldb:3306/pageviewservice \
-e SPRING_PROFILES_ACTIVE=mysql  \
-e SPRING_RABBITMQ_HOST=rabbitmq \
artarkatesoft/pageviewservice

# Using Maven for CI Builds
mvn clean verify docker:push

# View logs from Maven
## Logs from all containers
mvn docker:logs -Ddocker.follow
## Logs from certain container by image tag
mvn docker:logs -Ddocker.follow -Ddocker.filter=artarkatesoft/springbootdocker
## Logs from certain container by container name
mvn docker:logs -Ddocker.follow -Ddocker.filter=spring-boot-docker
## Logs from several containers
mvn docker:logs -Ddocker.follow -Ddocker.filter=spring-boot-docker,myrabbitmq
mvn docker:logs -Ddocker.follow -Ddocker.filter=spring-boot-docker,springframeworkguru/pageviewservice

# Docker Compose Commands

#start docker compose in background
docker-compose up -d

#stop docker-compose
docker-compose down

# Docker Swarm Commands

## Create portainer service in docker swarm
docker service create \
--name portainer \
--publish 9000:9000 \
--constraint 'node.role == manager' \
--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
portainer/portainer \
-H unix:///var/run/docker.sock

## ssh to node on DigitalOcean
ssh -i "~/.ssh/<your key here>"  root@<your node ip here>

#Init Docker Swarm
docker swarm init

## Create portainer service in docker swarm on port 80
docker service create \
--name portainer \
--publish 80:9000 \
--constraint 'node.role == manager' \
--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
portainer/portainer \
-H unix:///var/run/docker.sock

## force new quorum
docker swarm init --force-new-cluster --advertise-addr node3:2377

# MySQL Service
docker service create \
--name mysqldb -p 3307:3306 \
-e MYSQL_DATABASE=pageviewservice \
-e MYSQL_ALLOW_EMPTY_PASSWORD=yes \
mysql

# List Processes in service
docker service ps mysqldb

## RabbitMQ Service
docker service create --name myrabbitmq -p 5671:5671 -p 5672:5672 -d rabbitmq

## Page View Service
docker service create  --name pageviewservice -p 8081:8081 -d \
-e SPRING_DATASOURCE_URL=jdbc:mysql://mysqldb:3306/pageviewservice \
-e SPRING_PROFILES_ACTIVE=mysql  \
-e SPRING_RABBITMQ_HOST=myrabbitmq \
artarkatesoft/pageviewservice

## Web App Service
docker service create --name webapp -p 8080:8080 -d \
  -e SPRING_RABBITMQ_HOST=myrabbitmq artarkatesoft/springbootdocker
