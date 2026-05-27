#!/usr/bin/env bash

set -e

NETWORK="mynet"
IMAGE_NAME="mywordpress"
IMAGE_TAG="v1"
FULL_IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"
CONTAINER_NAME="wp1"
HOSTNAME_NAME="wp1"

VOLUME_MAPPING="/home/admin/docker/wordpress:/storage"
PORT_MAPPING="8080:80"


IMAGE_NAME2="mymariadbwp"
IMAGE_TAG2="v1"
FULL_IMAGE2="${IMAGE_NAME2}:${IMAGE_TAG2}"
CONTAINER_NAME2="dbwp1"
HOSTNAME_NAME2="dbwp1"

VOLUME_MAPPING2="/home/admin/docker/wordpress:/storage"
PORT_MAPPING2="3306:3306"

#Usage
usage() {
    echo "Használat: $0 {install|remove}"
    exit 1
}

#Check params
if [ $# -ne 1 ]; then
    usage
fi

case "$1" in
    install)
	echo "[INFO] Docker network..."
	if [ -z "$(docker network list -f "name={$NETWORK}" -q)" ]; then
	    echo "[INFO] Docker network... OK"
	    else
	    echo "[INFO] Docker network create..."
	    docker create network $NETWORK
	fi
	cd ./wp
        echo "[INFO] Docker image build..."
        # docker build -t mytag .
	docker build -t "$FULL_IMAGE" .
        echo "[INFO] Container létrehozása..."
        docker create -it \
            -v "$VOLUME_MAPPING" \
            -p "$PORT_MAPPING" \
            --name "$CONTAINER_NAME" \
            --hostname "$HOSTNAME_NAME" \
            --network "$NETWORK" \
            "$FULL_IMAGE"

        echo "[INFO] Container indítása..."
        docker start "$CONTAINER_NAME"
        cd ..
        
	cd ./dbwp
        echo "[INFO] Docker image build..."
        # docker build -t mytag .
	docker build -t "$FULL_IMAGE2" .
        echo "[INFO] Container létrehozása..."
        docker create -it \
            -v "$VOLUME_MAPPING2" \
            -p "$PORT_MAPPING2" \
            --name "$CONTAINER_NAME2" \
            --hostname "$HOSTNAME_NAME2" \
            --network "$NETWORK" \
            "$FULL_IMAGE2"

        echo "[INFO] Container indítása..."
        docker start "$CONTAINER_NAME2"
        echo "[INFO] Run SQL script..."
        sleep 10
        docker exec -it "$CONTAINER_NAME2" /bin/bash -c "mysql < /sql/SQL.txt"
        cd ..
        ;;
    
    remove)
        echo "[INFO] Container leállítása és törlése..."
        docker stop "$CONTAINER_NAME" || true
        docker rm "$CONTAINER_NAME" || true

        echo "[INFO] Image törlése..."
        docker rmi "$FULL_IMAGE" || true

        echo "[INFO] Container leállítása és törlése..."
        docker stop "$CONTAINER_NAME2" || true
        docker rm "$CONTAINER_NAME2" || true

        echo "[INFO] Image törlése..."
        docker rmi "$FULL_IMAGE2" || true

        ;;
    
    *)
        usage
        ;;
esac
