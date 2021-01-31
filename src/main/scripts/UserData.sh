#!/bin/bash

yum check-update
curl -fsSL https://get.docker.com/ | sh
systemctl start docker
systemctl enable docker