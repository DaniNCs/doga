#!/bin/bash

docker build -t myfedora-mariadb:v1 -f ./Dockerfile-mariadb .

docker create -it -v /home/admin:/shared -p 33066:3306 --name myfedora-mariadb --hostname myfedora-mariadb myfedora-mariadb:v1

docker start myfedora-mariadb