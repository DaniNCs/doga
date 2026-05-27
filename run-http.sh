#!/bin/bash

docker build -t myfedora-http:v1 -f ./Dockerfile-http .

docker create -it -v /home/admin:/shared -p 8000:80 -p 4438:443 --name myfedora-http --hostname myfedora-http myfedora-http:v1

docker start myfedora-http

