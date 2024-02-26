#!/bin/bash

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"

DOCKER_VOLUMES="
--env="DISPLAY=$DISPLAY" \
--env="QT_X11_NO_MITSHM=1" \
--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
--volume="${HOME}/repos:/home/ros/repos" \
--volume="/dev/shm:/dev/shm" \
--env="XAUTHORITY=$XAUTH" \
--volume="$XAUTH:$XAUTH" \
--runtime=nvidia \
--mount source="/home/$USER/shared",target="/shared",type=bind \
"

DOCKER_ARGS=${DOCKER_VOLUMES}

# container neither running nor stopped? → create
if [[ -z "$(docker ps -a -q -f name='ros2')" ]]
then
echo "creating container"
docker create -i -t --name ros2 \
                --net=host \
                --ipc=host \
                --pid=host \
                --privileged  \
                --device-cgroup-rule "c 81:* rmw" \
                --device-cgroup-rule "c 189:* rmw" \
                ${DOCKER_ARGS} \
                ${REPOSITORY_NAME} zsh
fi

# container not running? → start
if [[ -z "$(docker ps -q -f name='ros2')" ]];
then
  docker container start ros2
fi

docker container exec -it ros2 /entrypoint.sh
