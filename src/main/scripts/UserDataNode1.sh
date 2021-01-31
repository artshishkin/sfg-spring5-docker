#!/bin/bash

yum check-update
curl -fsSL https://get.docker.com/ | sh
systemctl start docker
systemctl enable docker

docker swarm init --advertise-addr eth1:2377

docker service create \
--name portainer \
--publish 9000:9000 \
--constraint 'node.role == manager' \
--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
portainer/portainer \
-H unix:///var/run/docker.sock