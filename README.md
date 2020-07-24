# sfg-spring5-docker
SFG Tutorial on Docker

## Section 13 - Introduction to Docker

### `253` Hello World with Docker
```
sudo docker run hello-world
```
### `254` Docker Hub
### `255` Introducing KiteMatic
### `256` Assignment - Run Hello World Nginx

## Section 14 - Working with Containers and Images

### `259` Running Mongo DB Docker Container
- $`sudo docker run mongo` - must be opened window
- $`sudo docker run -d mongo` - detached run (`-d`) (Ports  27017/tcp)
- $`sudo docker stop 8942c385b18c` - then from any terminal to stop running
- $`docker ps` - then no one running (`ps` - List containers)
- $`sudo docker run -p 27017:27017 -d mongo` (Ports   0.0.0.0:27017->27017/tcp) - to connect external app to db

### `260` Assignment - Download and Run Spring Boot Project
- `sudo docker logs 84ec26572063`
- `mvn spring-boot:run`

### Detach Spring Boot app
- `screen spring-boot:run`
- Ctrl-A -> D - to detach
- `screen -r` - to attach

### `262` Docker Images
- `sudo docker image inspect mongo`
- `sudo docker images -q --no-trunc` - IDs of Images Full (SHA256 of image)
- `sudo docker images` - REPOSITORY-TAG-IMAGE ID(12 characters of sha256)-CREATED-SIZE
- Image Tag Names: format: [REGISTRYHOST/][USERNAME/]NAME[:TAG] (registry.hub.docker.com/mongo:latest) 

### `265` Assigning storage (enables to store data between start-stop mongo container)
- `sudo docker run -p 27017:27017 -v /home/art/dockerdata/mongo:/data/db -d mongo` 
Usefull command:
- `history | grep mongo`
- `!252` - for example - to repeat command

### `266` Run Rabbit MQ Container - Assignment
- `sudo docker run -p 4369:4369 -p 5671:5671 -p 5672:5672 -p 25672:25672 -d --hostname art-rabbit --name artRabbit rabbitmq:3` - without managment console
- `sudo docker run -d --hostname art-rabbit --name rabbitMan2 -p 8080:15672 -p 5671:5671 -p 5672:5672 rabbitmq:3-management` - with management console on 8080 

### `268` Run MySQL in a Container - Assignment
- `sudo docker run --name art-mysql -v /home/art/dockerdata/mysql:/var/lib/mysql -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:latest`
- `sudo docker run --name art-mysql -v /home/art/dockerdata/mysql:/var/lib/mysql -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql` - without tag - will use `latest`

### `270` Docker House Keeping
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
