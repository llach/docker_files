#!/bin/bash

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"
CNAME=${1:-ros2}

DOCKER_VOLUMES="
-e DISPLAY=${IP}:0 \
-e XAUTHORITY=/root/.Xauthority \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--volume="${XAUTHORITY:-$HOME/.Xauthority}:/root/.Xauthority" \
--volume="${HOME}/repos:/home/ros/repos" \
"

DOCKER_ARGS=${DOCKER_VOLUMES}

# container neither running nor stopped? → create
if [[ -z "$(docker ps -a -q -f name=${CNAME})" ]]
then
echo "creating container"
docker create -i -t --name ${CNAME} \
                --net=host \
                --ipc=host \
                --hostname="$(hostname)" \
                --privileged  \
                ${DOCKER_ARGS} \
                ${REPOSITORY_NAME} zsh
fi

# container not running? → start
if [[ -z "$(docker ps -q -f name=${CNAME})" ]];
then
  docker container start ${CNAME}
fi

docker container exec -it ${CNAME} /entrypoint.sh
