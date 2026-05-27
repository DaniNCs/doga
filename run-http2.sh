#!/bin/bash

docker build -t myfedora-http2:v1 -f ./Dockerfile-http2 .

docker create -it -v /home/admin:/shared -v /home/admin/docker/fedora/www:/var/www/html -p 8000:80 -p 4438:443 --name myfedora-http2 --hostname myfedora-http2 myfedora-http2:v1

docker start myfedora-http2