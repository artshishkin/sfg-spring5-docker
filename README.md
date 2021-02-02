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
        
### `78` Creating a Multi Node Docker Swarm (using Docker Droplet image)

1.  Create new project        
    -  `Testing Docker Droplet`
2.  Create 1 Droplet from Docker
    -  Marketplace application -> Docker
3.  Init Swarm mode
    -  `ssh -i ~\.ssh\digital_ocean root@64.227.113.177`
    -  `docker swarm init --advertise-addr 64.227.113.177`
        -  `docker swarm join --token SWMTKN-1-4j2l94oevk7ed6992xrem416t2dsahlhhifm0jwycszw9z04i8-derdscf6rced0o3ickr2y7rja 64.227.113.177:2377`
4.  Add 4 Worker Nodes
    -  4 Docker Droplets
    -  UserData -> just
        -  `#!/bin/bash`
        -  `docker swarm join --token SWMTKN-1-4j2l94oevk7ed6992xrem416t2dsahlhhifm0jwycszw9z04i8-derdscf6rced0o3ickr2y7rja 64.227.113.177:2377`
    -  Tested -> Does not work properly
    -  port 2377 is not opened by default
```
Welcome to DigitalOcean's 1-Click Docker Droplet.
To keep this Droplet secure, the UFW firewall is enabled.
All ports are BLOCKED except 22 (SSH), 2375 (Docker) and 2376 (Docker).

* The Docker 1-Click Quickstart guide is available at:
  https://do.co/3j6j3po#start

* You can SSH to this Droplet in a terminal as root: ssh root@139.59.151.124

* Docker is installed and configured per Docker's recommendations:
  https://docs.docker.com/install/linux/docker-ce/ubuntu/

* Docker Compose is installed and configured per Docker's recommendations:
  https://docs.docker.com/compose/install/#install-compose
```

### Using Private VPC network in Docker Swarm Mode

1.  Use Default private VPC network
    -  create CentOS droplet with UserData    
    -  `docker swarm init --advertise-addr eth1:2377`
        -  `docker swarm join --token SWMTKN-1-2nmjcgvhxe2k0ys8u28ck0k5ntu3d0tywkm7f74q4berj8oyh3-b4c7ehbjo7jcpcm6dqyvcnpxw 10.114.0.2:2377`
    -  create another CentOS droplet with UserData and join-token
    -  works well
2.  Use Custom private VPC
    -  create 
        -  Manage -> Networking ->
        -  VPC -> Create VPC Network
    -  repeat all the steps from 1 with custom VPC Network       

###  `79` Assignment - Install Portainer

1.  Create Swarm manager
    -  use UserData.sh
    -  add `docker swarm init --advertise-addr eth1:2377` to use Private network
    -  add service `portainer`
    -  look final `UserDataNode1.sh`
    -  ssh to it
    -  `ssh -i ~\.ssh\digital_ocean root@64.227.113.177`
    -  `docker swarm join --token SWMTKN-1-2lfo9ka1l9u68dlqyf6pq07iqtcdnfy8z1c9wnr2ld6r6wmq2q-5zkpsy1tllxxg1poymekfrd0e 10.114.16.2:2377`              
2.  View portainer status
    -  `http://64.227.113.177:9000` 
3.  Create 4 Swarm workers
    -  add join-token to UserData
    -  demote 2 nodes to worker
4.  Experiment `Leader down`
    -  Application -> Resources -> node1 -> Off
    -  browse to another manager
    -  `http://104.248.132.96:9000/`
    -  view Dashboard -> Services -> portainer -> moved from node1 to node6
    -  node6 -> Off
    -  browse to last manager -> node7
    -  `http://159.65.116.203:9000/` -> 404
    -  ssh to 159.65.116.203
    -  `docker node ls`
        -  Error response from daemon: rpc error: code = Unknown desc = The swarm does not have a leader. It's possible that too few managers are online. Make sure more than half of the managers are online.  
        -  NO QUORUM (must be more then 50 % of running managers)
    -  node1 UP
    -  node7 -> `docker node ls` -> 
        -  node1 Reachable, node7 Leader, node6 Unreachable
    -  `http://159.65.116.203:9000/` -> OK
5.  Experiment `Managers are killed`
    -  node1 -> Destroy
    -  node6 -> Destroy
    -  `http://159.65.116.203:9000/` -> 404
    -  node7 -> `docker node ls`
        -  Error response from daemon: rpc error: code = Unknown desc = The swarm does not have a leader. It's possible that too few managers are online. Make sure more than half of the managers are online.
    -  reinitialize swarm cluster
    -  `docker swarm init --force-new-cluster --advertise-addr eth1:2377`
    -  `docker node ls`
        -  HOSTNAME   STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
        -  node1      Down      Active                          20.10.2
        -  node6      Down      Active                          20.10.2
        -  node7      Ready     Active         Leader           20.10.2
        -  node8      Ready     Active                          20.10.2
        -  node9      Ready     Active                          20.10.2
    -  `docker service ls` - portainer OK
    -  `docker node promote node8 node9`

###  Enabling ports for a Multi Node Docker Swarm Cluster using Docker Droplet image
    
1.  [Set UP Firewall UFW in Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04-ru)
2.  Create Docker Droplet for tuning
    -  create 2 instances
3.  SSH into them
    -  `ufw status`
        -  Status: active
        -  To                         Action      From
        -  --                         ------      ----
        -  22/tcp                     LIMIT       Anywhere
        -  2375/tcp                   ALLOW       Anywhere
        -  2376/tcp                   ALLOW       Anywhere
        -  22/tcp (v6)                LIMIT       Anywhere (v6)
        -  2375/tcp (v6)              ALLOW       Anywhere (v6)
        -  2376/tcp (v6)              ALLOW       Anywhere (v6)
4.  Required open ports  
    -  TCP port 2377 for cluster management communications
    -  TCP and UDP port 7946 for communication among nodes
    -  UDP port 4789 for overlay network traffic
    -  If you plan on creating an overlay network with encryption (--opt encrypted), you also need to ensure ip protocol 50 (ESP)        
5.  [Configure the Linux Firewall for Docker Swarm on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-configure-the-linux-firewall-for-docker-swarm-on-ubuntu-16-04)
    -  ufw allow 22/tcp
    -  ufw allow 2376/tcp
    -  ufw allow 2377/tcp
    -  ufw allow 7946/tcp
    -  ufw allow 7946/udp
    -  ufw allow 4789/udp    
6.  My config 1 
    -  ufw allow 22/tcp (not necessary, already configured in Docker Droplet image)
    -  ufw allow in on eth1 to any port 2376/tcp (not necessary, already configured in Docker Droplet image)
    -  ~~ufw allow in on eth1 to any port 2377/tcp~~  (ERROR: Bad port '4789/udp')
        -  ufw allow in on eth1 to any port 2377
    -  ufw allow in on eth1 to any port 7946
    -  ~~ufw allow in on eth1 to any port 4789/udp~~ (ERROR: Bad port '4789/udp')
        -  ufw allow in on eth1 to any port 4789
    -  `ufw status numbered`
    -  delete unnecessary rules
        -  `ufw delete 8`
7.  My config 2
    -  ufw allow in on eth1 to any port 2377 proto tcp     
    -  ufw allow in on eth1 to any port 7946
    -  ufw allow in on eth1 to any port 4789 proto udp
8.  Testing
    -  ssh to both nodes
    -  node1 -> `docker swarm init --advertise-addr eth1:2377`
    -  node2 -> `docker swarm join --token SWMTKN-1-0vxocicdheh3smn1seebhjtd2hpdivbs9r1p39wcdhr6pgyb08-0n0by6c2ne8w6sydfqvwyk2mm 10.114.16.2:2377`    
    -  node1 -> `docker node ls` -> 1 manager, 1 worker -> OK
    -  Cleanup -> Destroy 2 droplets
9. Final algorithm
    -  Start node1
        -  Use UserData from [UserDataDockerDroplet\UserDataNode1.sh](https://github.com/artshishkin/sfg-spring5-docker/blob/master/src/main/scripts/UserDataDockerDroplet/UserDataNode1.sh)
        -  SSH to it
            -  `ssh -i ~\.ssh\digital_ocean root@167.71.62.227`
        -  get join-token
            -  `docker swarm join-token worker` -> save it
    -  Start other nodes
        -  insert join-token to UserData
        -  Use UserData from [UserDataDockerDroplet\UserDataNode2345.sh](https://github.com/artshishkin/sfg-spring5-docker/blob/master/src/main/scripts/UserDataDockerDroplet/UserDataNode2345.sh)
    -  Browse to  `node1:9000` -> portainer                               

##  Section 9: Running Java Apps in Docker Swarm

### `86` Deploy MySQL as Service in Docker Swarm

-  Start Cluster on CentOS
-  Start service `mysql:5.7` by using commands 
```shell script
docker service create \
--name mysqldb -p 3306:3306 \
-e MYSQL_DATABASE=pageviewservice \
-e MYSQL_ALLOW_EMPTY_PASSWORD=yes \
mysql:5.7
```
-  Test it runs
    -  `docker service ps mysqldb`
-  **OR**
-  Start service `mysql:5.7` by using portainer
    -  Portainer Console -> Endpoints -> Primary -> Services
    -  Add service
        -  Name: `mysqldbc`
        -  Registry: Docker.io
        -  Image: mysql:5.7
        -  Replicas: 1
        -  Port mapping: 3307:3306 (for solving conflicts)
        -  Environment variables:
            -  MYSQL_DATABASE: pageviewservice
            -  MYSQL_ALLOW_EMPTY_PASSWORD: yes            
        -  Create the service
-  Test connection
    -  Using MySQL Workbench create 2 connections to any IP of cluster, port 3306 and 3307
    -  OK

###  Replacing SFG image with `artarkatesoft` 

1.  Change docker.image prefix from `springframeworkguru/pageviewservice` to `artarkatesoft/pageviewservice`
2.  Build image
    -  `mvn clean package docker:build`
3.  Push to Dockerhub    
    -  `mvn docker:push` -> were problems with authentication (work around with docker itself)
    -  `docker image push artarkatesoft/pageviewservice` - OK 
4.  Test image is working
    -  modify [scripts\testing-environment\docker-compose.yml](https://github.com/artshishkin/sfg-spring5-docker/blob/master/src/main/scripts/testing-environment/docker-compose.yml)
    -  change `pageviewservice` to use image `artarkatesoft/pageviewservice`
    -  `docker-compose up -d`
    -  run `SfgDockerCourseApplication`
    -  curl localhost:8080 -> PageViewEvent sent -> Received Persisted
5.  Modify and test total `art-app` docker compose file

###  `87` Docker Overlay Networks (WRONG service creation)

-  MySQL Service
```shell script
docker service create \
--name mysqldb -p 3306:3306 \
-e MYSQL_DATABASE=pageviewservice \
-e MYSQL_ALLOW_EMPTY_PASSWORD=yes \
mysql
```
-  RabbitMQ Service
```shell script
docker service create --name myrabbitmq -p 5671:5671 -p 5672:5672 -d rabbitmq
```
- Page View Service
```shell script
docker service create  --name pageviewservice -p 8081:8081 -d \
-e SPRING_DATASOURCE_URL=jdbc:mysql://mysqldb:3306/pageviewservice \
-e SPRING_PROFILES_ACTIVE=mysql  \
-e SPRING_RABBITMQ_HOST=myrabbitmq \
artarkatesoft/pageviewservice
```
- Web App Service
```shell script
docker service create --name webapp -p 8080:8080 -d \
  -e SPRING_RABBITMQ_HOST=myrabbitmq artarkatesoft/springbootdocker
```
-  curl localhost:8080 -> Got an Error
```
2021-02-01 14:27:14.382  INFO 1 --- [nio-8080-exec-1] o.s.a.r.c.CachingConnectionFactory       : Attempting to connect to: [myrabbitmq:5672]
webapp.1.eg6pkq73lln5@docker-desktop    | 2021-02-01 14:27:24.409 ERROR 1 --- [nio-8080-exec-1] o.a.c.c.C.[.[.[/].[dispatcherServlet]    : Servlet.service() for servlet [dispatcherServlet] in context with path [] threw exception [Request processing failed; nested exception is org.springframework.amqp.AmqpIOException: java.net.UnknownHostException: myrabbitmq: Name or service not known] with root cause
webapp.1.eg6pkq73lln5@docker-desktop    |
webapp.1.eg6pkq73lln5@docker-desktop    | java.net.UnknownHostException: myrabbitmq: Name or service not known
```
-  `docker service inspect webapp`
    -  log is [swarm-logs/webapp-wrong.json](src/main/scripts/swarm-logs/webapp-wrong.json)
-  `docker service inspect myrabbitmq`
    -  log is [swarm-logs/myrabbitmq-wrong.json](src/main/scripts/swarm-logs/myrabbitmq-wrong.json)
-  `docker network ls`
    -  NETWORK ID     NAME                    DRIVER    SCOPE
    -  48bf18ff19cd   bridge                  bridge    local
    -  41172f0647f2   docker_gwbridge         bridge    local
    -  3110841fafc8   host                    host      local
    -  **7gvxxa0y157a   ingress                 overlay   swarm**
    -  3e397442a1fa   my_app_net              bridge    local
    -  f1ef2f70c963   network_elasticsearch   bridge    local
    -  f225feb00d43   none                    null      local    
-  cleanup
    -  `docker service rm mysqldb pageviewservice myrabbitmq webapp`
        
### `87` Docker Overlay Networks (RIGHT)

-  Create network first
    -  `docker network create --driver overlay art-service-network`
-  Create services with this network
```shell script

# Create network first
docker network create --driver overlay art-service-network

# MySQL Service
docker service create \
--name mysqldb -p 3307:3306 \
--network art-service-network \
-e MYSQL_DATABASE=pageviewservice \
-e MYSQL_ALLOW_EMPTY_PASSWORD=yes \
mysql:5.7

## RabbitMQ Service
docker service create --name myrabbitmq --network art-service-network -p 5671:5671 -p 5672:5672 -d rabbitmq

## Page View Service
docker service create  --name pageviewservice -p 8081:8081 -d \
--network art-service-network \
-e SPRING_DATASOURCE_URL=jdbc:mysql://mysqldb:3306/pageviewservice?useSSL=false \
-e SPRING_PROFILES_ACTIVE=mysql  \
-e SPRING_RABBITMQ_HOST=myrabbitmq \
artarkatesoft/pageviewservice

## Web App Service
docker service create --name webapp -p 8080:8080 -d \
  --network art-service-network \
  -e SPRING_RABBITMQ_HOST=myrabbitmq artarkatesoft/springbootdocker
```
-  Test it 
    -  curl localhost:8080 -> event sent, received and persisted -> OK
-  `docker service inspect webapp`
    -  log is [swarm-logs/webapp-correct.json](src/main/scripts/swarm-logs/webapp-correct.json)
-  `docker service inspect myrabbitmq`
    -  log is [swarm-logs/myrabbitmq-correct.json](src/main/scripts/swarm-logs/myrabbitmq-correct.json)
    -  difference is another Network is present
-  "Networks": 
```json
[
  {
    "Target": "t63mgujigmbb0ng5bg1kwzrjo"
  }
]
```
-  "VirtualIPs":
    
```json
[
  {
    "NetworkID": "7gvxxa0y157a8vbhagtzh3c7z",
    "Addr": "10.0.0.79/24"
  },
  {
    "NetworkID": "t63mgujigmbb0ng5bg1kwzrjo",
    "Addr": "10.0.1.5/24"
  }
]
```        
-  `docker network ls`
    -  NETWORK ID     NAME                    DRIVER    SCOPE
    -  **t63mgujigmbb   art-service-network     overlay   swarm**
    -  48bf18ff19cd   bridge                  bridge    local
    -  41172f0647f2   docker_gwbridge         bridge    local
    -  3110841fafc8   host                    host      local
    -  **7gvxxa0y157a   ingress                 overlay   swarm**
    -  3e397442a1fa   my_app_net              bridge    local
    -  f1ef2f70c963   network_elasticsearch   bridge    local
    -  f225feb00d43   none                    null      local

### `87` Docker Overlay Networks (BEST PRACTICE)

1.  Best practice is to split networks into a backend and a frontend
    -  `docker network create --driver overlay art-service-backend-network`
    -  `docker network create --driver overlay art-service-frontend-network`
2.  Use commands from [dockercommands.sh](src/main/scripts/dockercommands.sh)
    -  webapp: frontend
    -  myrabbitmq: frontend and backend
    -  pageviewservice: backend
    -  mysqldb: backend
3.  Hide unnecessary ports 

###  `88` Docker Swarm Stacks

-  `docker stack deploy -c docker-compose.yml art-app`
-  `docker stsack rm art-app`

###  `90` Implementing Docker Secrets

1.  Approach ONE - using file
    -  use file  [mysql_root_password.txt](src/main/scripts/art-app-swarm-stack-secret/mysql_root_password.txt) with mysql root password
    -  modify [docker-compose file](src/main/scripts/art-app-swarm-stack-secret/docker-compose.yml)
        1.  add secret `mysql-root-password` to the stack -> this tell Docker to read secret from file `mysql_root_password.txt` into secret storage
            -  root `secrets:` section in the bottom of the file
        2.  point that service `mysqld` uses it -> this tells Docker to copy secret file `mysql-root-password` into `/run/secrets/` directory inside container
            -  section `secrets:` under service `mysqld` section
        3.  tell container how to set up password for MYSQL
            -  `MYSQL_ROOT_PASSWORD_FILE: /run/secrets/mysql-root-password`
    -  adjust service `pageviewservice` to use plain text password (just for study to make everuthing work)
        -  `SPRING_DATASOURCE_PASSWORD: 'password'`
    -  deploy stack
        -  `docker stack deploy -c docker-compose.yml art-app`
        -  all OK
    -  bash into mysql docker container
        -  `docker container exec -it 49e27cbf549b bash`
        -  `cat /run/secrets/mysql-root-password`
            -  `password` - same as in `mysql_root_password.txt`
    -  remove stack
        -  `docker stack rm art-app`
            -  `...Removing secret art-app_mysql-root-password...`
            -  **secrets are being removed too**
            -  `docker secret ls` -> None        
          
2.  Approach TWO - using external (but from file)
    -  create external secret
        -  `docker secret create mysql-root-password mysql_root_password.txt`
    -  modify [docker-compose file](src/main/scripts/art-app-swarm-stack-secret/docker-compose.yml)
        -  tell Docker to use external secret for this stack -> `external: true`
    -  deploy stack
    -  view password in container
        -  `docker exec -it d48440dbb0b0  cat /run/secrets/mysql-root-password` -> `password` -> OK
    -  remove stack
        -  `docker stack rm art-app`
        -  `docker secret ls`
            ID                          NAME                  DRIVER    CREATED       UPDATED
            y8hfpbu8q892dsp5c6m7s9tey   mysql-root-password             5 hours ago   5 hours ago
        -  **when using EXTERNAL secret it is not being deleted during stack removal**
    -  remove secret
        -  `docker secret remove mysql-root-password`
    -  approach 2
        1.  create external secret from file
        2.  delete file
        3.  deploy stack using external secret
3.  Approach THREE - using external (from console)
    -  create external secret
        -  `echo "password" | docker secret create mysql-root-password -`
    -  use same [docker-compose file](src/main/scripts/art-app-swarm-stack-secret/docker-compose.yml) as for Approach 2   
    -  made same steps as for Approach 2 but in cloud (or [play-with-docker](https://labs.play-with-docker.com/))
    -  disadvantage
        -  `history` ->
            -  1  echo "password" | docker secret create mysql-root-password -
            -  2  docker service create --name portainer --publish 9000:9000 --constraint 'node.role == manager' --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock portainer/portainer -H unix:///var/run/docker.sock
            -  3  history            
        -  we can view history and find password
    -  after creating a password in cloud we can delete manager station 
        -  delete in play-with-docker.com        
        -  destroy in DigitalOcean
        -  terminate instance (EC2 on AWS)
    -  remove manager from swarm
        -  `docker node promote worker1` - first promote ex-worker
        -  start new worker (new Server for example) and join to swarm
            -  `docker swarm join --token SWMTKN-1-3o0gxtrivl0s4ag6ncynky87p9mjzskhpsaouzd1eb0nbrt03c-f13fthuyrlnsy5h26lncln8t7 192.168.0.19:2377`
        -  `docker node demote  manager1` - demote manager to worker
        -  `docker node rm  manager1` - remove manager
    -  approach 3
        1.  create external secret from console
        2.  terminate manager station
        3.  deploy stack using external secret
4.  Approach FOUR - using portainer
    -  Portainer console -> Secrets
    -  Add secret
        -  Name: `mysql-root-password`
        -  Secret: `password`
        -  Create the secret
    -  Deploy stack
    -  use same [docker-compose file](src/main/scripts/art-app-swarm-stack-secret/docker-compose.yml) as for Approach 2   
    -  made same steps as for Approach 2 but in cloud (or [play-with-docker](https://labs.play-with-docker.com/))
    -  approach 4
        -  create secret using portainer
        -  deploy stack          

###  Spring Boot Secrets in Docker Swarm

1.  Using `spring.config.location` environment variable and file `application.properties`
    -  was errors -> default application.properties did not peak up
2.  Using `spring.config.additional-location` environment variable and file `application.properties` 
    -  create `application.properties` with secrets
        -  `spring.datasource.password=password`
        -  use environment variable
        -  `SPRING_CONFIG_ADDITIONAL_LOCATION: 'file:/run/secrets/'`       
    
       














        