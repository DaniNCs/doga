#!/bin/bash

docker build -t myfedora-mysql:v1 -f ./Dockerfile-mysql .

docker create -it -v /home/admin:/shared -p 33006:3306 --name myfedora-mysql --hostname myfedora-mysql myfedora-mysql:v1

docker start myfedora-mysql