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
