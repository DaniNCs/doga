#!/bin/bash

docker build -t myfedora-flask:v1 -f ./Dockerfile-flask .

docker create -it -p 5000:5000 --name fedora-flask --hostname fedora-flask myfedora-flask:v1

docker start fedora-flask