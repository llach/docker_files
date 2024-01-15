#!/bin/bash

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"

DOCKER_USER=ros
DOCKER_GID=$(id -g)
DOCKER_UID=$(id -u)

echo "======================="
echo " Building docker image "
echo " IMAGE_TAG:   ${REPOSITORY_NAME}"
echo " DOCKER_USER: ${DOCKER_USER}"
echo " DOCKER_GID:  ${DOCKER_GID}"
echo " DOCKER_UID:  ${DOCKER_UID}"

docker rm -f ros2
docker build ${DOCKER_FILE_PATH} --build-arg USERNAME="${DOCKER_USER}"\
                                 --build-arg GID=${DOCKER_GID}\
                                 --build-arg UID=${DOCKER_UID}\
                                 --progress=plain \
                                 -f Dockerfile \
                                 -t "${REPOSITORY_NAME}" .
