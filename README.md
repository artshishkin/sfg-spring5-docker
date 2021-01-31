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

###  `65` Run Wordpress with Docker Compose

[Quickstart: Compose and WordPress](https://docs.docker.com/compose/wordpress/)
-  `docker-compose up -d`
-  `docker-compose down`

## Section 8: Docker Swarm Mode

### `73` Docker Swarm Mode Init

1.  Init swarm
    -  `docker swarm init`
    -  `docker info`
        -  Swarm: active
        -  NodeID: 7j6yonvvr21o6uzpp5ekcayyd
        -  Is Manager: true
        -  ClusterID: rpps04vpnzrcz7dtodhyupc88
        -  Managers: 2
        -  Nodes: 2
        -  A lot more info
    -  `docker node ls`
2.  Run `portainer` as service  
    -  View [portainer.io](https://www.portainer.io/solutions/docker)
    - [Deploy Portainer in Docker Swarm](https://documentation.portainer.io/v2.0/deploy/linux/)
        -  I have swarm cluster with 2 nodes (art and farm01)
        -  `curl -L https://downloads.portainer.io/portainer-agent-stack.yml -o portainer-agent-stack.yml`
        -  this will download `portainer-agent-stack.yml`
        -  `docker stack deploy -c portainer-agent-stack.yml portainer`
        -  will deploy agent on every node and 1 server
    -  `docker service ls`
        -  ID             NAME                  MODE         REPLICAS   IMAGE                           PORTS
        -  tsg1ew0wafks   portainer_agent       global       2/2        portainer/agent:latest
        -  8a8kyvnxteqr   portainer_portainer   replicated   1/1        portainer/portainer-ce:latest   *:8000->8000/tcp, *:9000->9000/tcp 
3.  Set up `portainer`
    -  browse to `http://art:9000`
    -  set password
4.  I can not see all the features that SFG shows
5.  Clean UP
    -  `docker stack rm portainer`    

###  Trying older version of portainer

-  Start portainer

```shell script
## Create portainer service in docker swarm
docker service create \
--name portainer \
--publish 9000:9000 \
--constraint 'node.role == manager' \
--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
portainer/portainer \
-H unix:///var/run/docker.sock
```
-  Set up `portainer`
    -  browse to `http://art:9000`
    -  set password
-  Deploy Wordpress stack
    -  Stacks -> Add stack
    -  Name: `art-wordpress`
    -  Web editor -> Insert `wordpress/docker-compose.yml` content
    -  Deploy the stack

### `75` Provision Servers for Docker Swarm

1.  One opportunity [play-with-docker](https://labs.play-with-docker.com/)
2.  Digital Ocean
    -  Create Droplets -> Distributions -> CentOS **CHOOSE v7** (with 8 were problems)
    -  Authentication
        -  Password
        -  SSH keys -> New SSH Key
            -  `ssh-keygen`
            -  Enter file in which to save the key (C:\Users\Admin/.ssh/id_rsa): C:\Users\Admin\.ssh\digital_ocean_centos
            -  Enter passphrase (empty for no passphrase): {MY_PASSWORD}DIGITAL
                -  Your public key has been saved in C:\Users\Admin\.ssh\digital_ocean_centos.pub.
                -  The key fingerprint is:
                -  SHA256:YtdUkKvGVdDGD/pZHHkrn3kJvTzjPD0zS0Xt65YYWno admin@ArtRed16                
        -  `cat .\.ssh\digital_ocean_centos.pub` -> paste it into `SSH key Content` window
    -  One droplet for now (SFG made 4)
    -  Create
3.  SSH to it
    -  `ssh -i /path/to/private/key username@203.0.113.0`
    -  `ssh -i ~\.ssh\digital_ocean_centos root@46.101.131.133`
    -  Enter passphrase for key 'C:\Users\Admin/\.ssh\digital_ocean_centos': {enter passphrase} -> OK
    -  `whoami` -> root           
            
### `76` Assignment - Install Docker on Swarm Servers

1. Use [https://get.docker.com/](https://get.docker.com/)
    -  `curl -fsSL https://get.docker.com -o get-docker.sh`
    -  `sh get-docker.sh`    
    -  **OR**
2.  [How To Install and Use Docker on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-centos-7)
    -  `yum check-update`
    -  `curl -fsSL https://get.docker.com/ | sh`
    -  `systemctl start docker`
    -  `systemctl status docker` - verify docker is **running**
    -  `systemctl enable docker` - make it to start at every server reboot
3.  Create UserData
    -  to speed up installation create `UserData.sh` file
    -  Create Droplet -> CentOS 7.6
    -  Select additional options -> UserData -> paste it from `UserData.sh`     

### `78` Creating a Multi Node Docker Swarm (using CentOS Droplet)

1.  Swarm init
    -  SSH to node 1: `ssh -i ~\.ssh\digital_ocean_centos root@159.89.11.219`
    -  `docker swarm init`
    -  Error occurred
    -  `Error response from daemon: could not choose an IP address to advertise since this system has multiple addresses on interface eth0 (46.101.192.228 and 10.19.0.5) - specify one with --advertise-addr`
    -  Choose public IP
    -  `docker swarm init --advertise-addr 46.101.192.228`
2.  Get join-token for another managers
    -  `docker swarm join-token manager`
    -  `docker swarm join --token SWMTKN-1-1i94vhswzcyz142qevb0pcqxs9pnxrysoscqyivsy2vk6q6p9v-9sgwiawgsf4hvgr4x1j6208sg 46.101.192.228:2377`                  
3.  Get join-token for workers
    -  `docker swarm join-token worker`
    -  `docker swarm join --token SWMTKN-1-1i94vhswzcyz142qevb0pcqxs9pnxrysoscqyivsy2vk6q6p9v-d4twjvj9k0cssiaiprqmesdxu 46.101.192.228:2377`                  
4.  Create 2 more managers
    -  add to UserData join-token execution
5.  Create 2 more workers
    -  add to UserData join-token execution        
    -  **OR**
6.  Just Create 4 Workers and Promote 2 of them into Manager
    -  create 1 manager
    -  `docker swarm init --advertise-addr 167.71.57.26`
        -  `docker swarm join --token SWMTKN-1-1cz8pjq0j8pgn655f1hqm4z29nx6vc29b5fs46xbzto8shkc7n-a9ea1d3v5ywsqak3spv7bc5br 167.71.57.26:2377`
    -  start 4 workers with UserData and join-token for connecting to Swarm as workers
    -  node1 - `docker node ls`
    -  when worker nodes become available promote 2 of them
    -  `docker node promote node2 node3`           
7.  Experiment `kill Leader`
    -  `ps -ef | grep docker`
        -  root      1455     1  0 17:45 ?        00:00:09 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
        -  root      2285  1607  0 18:13 pts/0    00:00:00 grep --color=auto docker`    
    -  `kill -9 1455`
    -  `reboot -f`
    -  node3 -> `docker node ls`
        -  Leader changed
        -  after rebooting node1 became Reachable