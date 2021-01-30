# Docker for Java Developers

---

Tutorial on Docker with Spring Boot from SFG (Spring Framework Guru) - Udemy

---

## Section 2 - Introduction to Docker

### `11` Hello World with Docker
```
sudo docker run hello-world
```
### `12` Docker Hub
### `13` Introducing KiteMatic
### `14` Assignment - Run Hello World Nginx
    
-  `docker container run -d -p 80:80 --name my-nginx nginx`
-  `curl localhost` -> OK
-  `docker container rm -f my-nginx` - remove container (`-f` - force stop and remove)
-  `docker container ls -a -f ancestor=nginx` - list all containers from image `nginx`
-  `docker container rm $(docker container ls -a -f ancestor=nginx -q)` - remove all containers from image `nginx`

## Section 3 - Working with Containers and Images

### `17` Running Mongo DB Docker Container
- $`sudo docker run mongo` - must be opened window
- $`sudo docker run -d mongo` - detached run (`-d`) (Ports  27017/tcp)
- $`sudo docker stop 8942c385b18c` - then from any terminal to stop running
- $`docker ps` - then no one running (`ps` - List containers)
- $`sudo docker run -p 27017:27017 -d mongo` (Ports   0.0.0.0:27017->27017/tcp) - to connect external app to db

### `18` Assignment - Download and Run Spring Boot Project
- `sudo docker logs 84ec26572063`
- `mvn spring-boot:run`

### Detach Spring Boot app
- `screen spring-boot:run`
- Ctrl-A -> D - to detach
- `screen -r` - to attach

### `20` Docker Images
- `sudo docker image inspect mongo`
- `sudo docker images -q --no-trunc` - IDs of Images Full (SHA256 of image)
- `sudo docker images` - REPOSITORY-TAG-IMAGE ID(12 characters of sha256)-CREATED-SIZE
- Image Tag Names: format: [REGISTRYHOST/][USERNAME/]NAME[:TAG] (registry.hub.docker.com/mongo:latest) 

### `23` Assigning storage (enables to store data between start-stop mongo container)
- `sudo docker run -p 27017:27017 -v /home/art/dockerdata/mongo:/data/db -d mongo` 
Usefull command:
- `history | grep mongo`
- `!252` - for example - to repeat command

### `24` Run Rabbit MQ Container - Assignment
- `sudo docker run -p 4369:4369 -p 5671:5671 -p 5672:5672 -p 25672:25672 -d --hostname art-rabbit --name artRabbit rabbitmq:3` - without managment console
- `sudo docker run -d --hostname art-rabbit --name rabbitMan2 -p 8080:15672 -p 5671:5671 -p 5672:5672 rabbitmq:3-management` - with management console on 8080 

### `26` Run MySQL in a Container - Assignment
- `sudo docker run --name art-mysql -v /home/art/dockerdata/mysql:/var/lib/mysql -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:latest`
- `sudo docker run --name art-mysql -v /home/art/dockerdata/mysql:/var/lib/mysql -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql` - without tag - will use `latest`

### `28` Docker House Keeping
#### Containers:
- `docker kill $(docker ps -q)` - Kill all Running Docker Containers (`sudo docker kill $(sudo docker ps -q)`)
- `docker rm $(docker ps -a -q)` - Delete all Stopped Docker Containers (`-q` - quet mode)
#### Images:
- `docker rmi <image name>` - remove docker image (`docker rmi a9ea0b189b4f`)
- `docker images` - show all images
- `docker images -q` - show TAGS of all images
- `docker rmi $(docker images -q -f dangling=true)` - delete Untagged (dangling) images
- `docker rmi $(docker images -q)` - delete all images
#### Volumes:
- `docker volume rm $(docker volume ls -f dangling=true -q)` - remove all dangling volumes

### Running docker through ssh without sudo
- [Manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/)
To create the docker group and add your user:
- Create the docker group.
```
sudo groupadd docker
```
- Add your user to the docker group.
```
sudo usermod -aG docker ${USER}
```
- You would need to loog out and log back in so that your group membership is re-evaluated

## Section 4 - Running Spring Boot in a CentOS Image
### `32` Preparing CentOS for Java development
- `docker run -d centos` -  executes and exits
- `docker run -d centos tail -f /dev/null` - some tricky workaround
- `docker  exec -it hopeful_shtern bash` (it - interactive mode, hopeful_shtern - container name (in this time))
- `whoami`
- `ps -ef` - processes
- `yum install java`

### `35` Running Spring Boot from Docker
- in `/tmp` create Dockerfile
- copy jar to `/tmp`
- from `/tmp` run `docker build -t spring-boot-docker .` (`-t` - tag image as `spring-boot-docker`, `.` - look in a local directory for Dockerfile)
- I moved to `/tmp/run_boot` and changed Dockerfile
- `docker run -d -p 8080:8080 spring-boot-docker`
- `docker ps`
- `docker logs ...`

## Section 5 - DevOps - Automating Building of Docker Images

### `42` Spring Boot Application Code Review

### Tasks
1.  Adding Fabric8 Maven Plugin (43)
2.  Enabling connect to remote docker daemon
    -  `https://nickjanetakis.com/blog/docker-tip-73-connecting-to-a-remote-docker-daemon`
3.  Creating Docker Image in Fabric 8 (44) 
    -  `mvn clean package docker:build`
4.  Pushing to Dockerhub (45)
    -  create dockerhub account
    -  add server to maven `settings.xml`:
    -  encrypt password by using `mvn --encrypt-password`
```xml
<server>
    <id>docker.io</id>
    <username>artarkatesoft</username>
    <password>{your_encrypted_password}</password>
</server>
```
    -  run `mvn clean package docker:build docker:push`

##  Section 6 - Running Images from Maven

### `52` Running a Docker image from Maven

    -  `mvn docker:run` - interactively
    -  `mvn docker:start` - detached (like `-d`)
    -  `mvn docker:stop` - stop

### `54` Application Code Review

1.  Clone repositories
    -  `git clone https://github.com/springframeworkguru/page-view-service-model.git`
    -  `git clone https://github.com/springframeworkguru/page-view-service.git`
    -  `git clone https://github.com/springframeworkguru/page-view-client.git`
2.  Create Empty project
    -  Add 4 modules (3 cloned and 1 `sfg-spring5-docker` from study course):
    -  File -> New -> Module from Existing Source
3.  Update `page-view-service-model`
    -  add dependencies to run in JVM11        
        -  `jakarta.xml.bind:jakarta.xml.bind-api:2.3.3`
        -  `com.sun.xml.bind:jaxb-impl:2.3.3<scope>runtime</scope>`
    -  version `1.4-SNAPSHOT`
    -  add properties
        -  <maven.compiler.source>${java.version}</maven.compiler.source>
        -  <maven.compiler.target>${java.version}</maven.compiler.target>        
    -  update version of `maven-javadoc-plugin` to 3.2.0
    -  exclude maven-gpg-plugin by moving execution to another phase
        -  <!--<phase>verify</phase>-->
        -  <phase>deploy</phase>            
    -  install module into local Maven repository
        -  `mvn clean package install`              
4.  Update `page-view-service`
    -  application.properties - use 3307
        -  `spring.datasource.url=jdbc:mysql://localhost:3307/pageviewservice?useSSL=false`
    -  add dependencies to run in JVM11        
        -  `jakarta.xml.bind:jakarta.xml.bind-api:2.3.3`
        -  `com.sun.xml.bind:jaxb-impl:2.3.3<scope>runtime</scope>`
        -  `org.javassist:javassist:3.25.0-GA` - for Hibernate
    -  modify version of `page-view-service-model` to `1.4-SNAPSHOT`
5.  Update `page-view-client`
    -  add dependencies to run in JVM11        
        -  `jakarta.xml.bind:jakarta.xml.bind-api:2.3.3`
        -  `com.sun.xml.bind:jaxb-impl:2.3.3<scope>runtime</scope>`
    -  modify version of `page-view-service-model` to `1.4-SNAPSHOT`
    -  update version of `maven-javadoc-plugin` to 3.2.0
    -  exclude maven-gpg-plugin by moving execution to another phase
        -  <!--<phase>verify</phase>-->
        -  <phase>deploy</phase>     
    -  install module into local Maven repository
        -  `mvn clean package install`
6.  Modify `sfg-spring5-docker` to use Page View Client version `0.0.3-SNAPSHOT` 
7.  Using `dockercommands.sh` start required containers
    -  `docker run --name mysqldb -p 3307:3306 -e MYSQL_DATABASE=pageviewservice -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql`
    -  port 3307 because I have MySQL installed
    -  `docker run --name rabbitmq -p 5671:5671 -p 5672:5672 -d rabbitmq`
8.  Run `page-view-service`
9.  Run `sfg-spring5-docker`     
10.  Test it
    -  browse to `http://localhost:8080`
    -  click 1 page `http://localhost:8080/product/1`
    -  view logs in 2 projects
        -  Send and Received messages must be equal
    -  mysql data should update correctly

### `55` Running Example Application with Docker

1.  Start containers using command in `dockercommands.sh`
    -  `docker run --name mysqldb -p 3307:3306 -e MYSQL_DATABASE=pageviewservice -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:5.7`
    -  `docker run --name rabbitmq -p 5671:5671 -p 5672:5672 -d rabbitmq`
2.  Start `pageviewservice` docker container
3.  Start `sfg-spring5-docker` -> Test it
4.  Got errors in `pageviewservice` with hibernate
5.  Rebuild docker image `springframeworkguru/pageviewservice`
    -  modify DockerfileTemplate: `FROM openjdk:11-jdk`
    -  <maven-surefire-plugin.version>3.0.0-M1</maven-surefire-plugin.version>
    -  <dockerHost>tcp://127.0.0.1:2375</dockerHost>  
    -  update version `io.fabric8:docker-maven-plugin:0.33.0`  
    -  update version of `maven-javadoc-plugin` to 3.2.0
    -  exclude maven-gpg-plugin by moving execution to another phase
        -  <!--<phase>verify</phase>-->
        -  <phase>deploy</phase>
    -  build Docker image:
        -  `mvn clean package docker:build`
6.  Start `pageviewservice` docker container
7.  Start `sfg-spring5-docker` -> Test it ->All OK
        
###  `56` Running Docker Containers via Maven        
        
-  `mvn clean package docker:start` - just start        
-  `mvn clean package docker:build docker:start` - build and start         
-  `mvn clean package docker:stop docker:build docker:start` - stop first 
-  `mvn docker:run` - interactively (with logs)      
        
###  `58` Using Maven for CI Builds

-  `mvn clean package verify docker:push`
-  `mvn clean verify docker:push` - even simpler

### View logs from Maven

```shell script
# Logs from all containers
mvn docker:logs -Ddocker.follow
## Logs from certain container by image tag
mvn docker:logs -Ddocker.follow -Ddocker.filter=artarkatesoft/springbootdocker
## Logs from certain container by container name
mvn docker:logs -Ddocker.follow -Ddocker.filter=spring-boot-docker
## Logs from several containers
mvn docker:logs -Ddocker.follow -Ddocker.filter=spring-boot-docker,myrabbitmq
mvn docker:logs -Ddocker.follow -Ddocker.filter=spring-boot-docker,springframeworkguru/pageviewservice
```


                     