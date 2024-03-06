#!/bin/bash

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"

DOCKER_USER=ros
DOCKER_GID=$(id -g)
DOCKER_UID=$(id -u)
ROS_DISTRO=humble

echo "======================="
echo " Building docker image "
echo " IMAGE_TAG:   ${REPOSITORY_NAME}"
echo " DOCKER_USER: ${DOCKER_USER}"
echo " DOCKER_GID:  ${DOCKER_GID}"
echo " DOCKER_UID:  ${DOCKER_UID}"

docker rm -f $REPOSITORY_NAME
docker build ${DOCKER_FILE_PATH} --build-arg USERNAME="${DOCKER_USER}"\
                                 --build-arg ROS_DISTRO=${ROS_DISTRO}\
                                 --build-arg GID=${DOCKER_GID}\
                                 --build-arg UID=${DOCKER_UID}\
                                 -f Dockerfile \
                                 -t "${REPOSITORY_NAME}" .