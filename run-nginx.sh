#!/bin/bash

docker build -t myfedora-nginx:v1 -f ./Dockerfile-nginx .

docker create -it -v /home/admin:/shared -v /home/admin/docker/fedora/www:/usr/share/nginx/html/ -p 8000:80 -p 4438:443 --name myfedora-nginx --hostname myfedora-nginx myfedora-nginx:v1

docker start myfedora-nginx