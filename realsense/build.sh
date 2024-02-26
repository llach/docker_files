#!/bin/bash

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"
CNAME=rs-ros

DOCKER_USER=ros
DOCKER_GID=$(id -g)
DOCKER_UID=$(id -u)

echo "======================="
echo " Building docker image "
echo " IMAGE_TAG:   ${REPOSITORY_NAME}"
echo " DOCKER_USER: ${DOCKER_USER}"
echo " DOCKER_GID:  ${DOCKER_GID}"
echo " DOCKER_UID:  ${DOCKER_UID}"

docker rm -f $CNAME
docker build ${DOCKER_FILE_PATH} --build-arg LIBRS_VERSION=2.50.0 \
                                 -f Dockerfile \
                                 -t "${REPOSITORY_NAME}" .
