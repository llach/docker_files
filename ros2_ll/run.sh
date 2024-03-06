#!/bin/bash

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"

# here you can append container creation arguments, such as volume creation etc.
DOCKER_ARGS="
--env="DISPLAY=$DISPLAY" \
--runtime=nvidia \
--mount source="/home/$USER/shared",target="/shared",type=bind \
--volume="/dev/shm:/dev/shm" \
"

# container neither running nor stopped? → create
if [[ -z "$(docker ps -a -q -f name=${REPOSITORY_NAME})" ]];
then
  echo "creating container"
  docker create -i -t --name ${REPOSITORY_NAME} \
                --net=host \
                --ipc=host \
                --hostname="$(hostname)" \
                --privileged  \
                ${DOCKER_ARGS} \
                ${REPOSITORY_NAME} zsh
fi

# container not running? → start
if [[ -z  "$(docker ps -q -f name=${REPOSITORY_NAME})" ]];
then
  echo "starting container"
  docker container start -a -i $REPOSITORY_NAME
else # else just start a new shell session in the container
  docker container exec -it $REPOSITORY_NAME zsh
fi