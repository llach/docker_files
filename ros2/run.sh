#!/bin/bash

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"

DOCKER_VOLUMES="
-e DISPLAY=${IP}:0 \
-e XAUTHORITY=/root/.Xauthority \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--volume="${XAUTHORITY:-$HOME/.Xauthority}:/root/.Xauthority" \
--volume="${HOME}/repos:/home/ros/repos" \
"

DOCKER_ARGS=${DOCKER_VOLUMES}

# container neither running nor stopped? → create
if [[ -z "$(docker ps -a -q -f name='ros2')" ]]
then
echo "creating container"
docker create -i -t --name ros2 \
                --net=host \
                --hostname="$(hostname)" \
                --privileged  \
                ${DOCKER_ARGS} \
                ${REPOSITORY_NAME} zsh
fi

# container not running? → start
if [[ -z "$(docker ps -q -f name='ros2')" ]];
then
  docker container start ros2
fi

docker container exec -it ros2 /entrypoint.sh
