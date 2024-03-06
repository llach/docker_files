#!/bin/bash

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"
CNAME=${1:-ros2}

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
if [[ -z "$(docker ps -a -q -f name=${CNAME})" ]]
then
echo "creating container"
docker create -i -t --name ${CNAME} \
                --net=host \
                --ipc=host \
                --hostname="$(hostname)" \
                --privileged  \
                --device-cgroup-rule "c 81:* rmw" \
                --device-cgroup-rule "c 189:* rmw" \
                ${DOCKER_ARGS} \
                ${REPOSITORY_NAME} zsh
fi

# container not running? → start
if [[ -z "$(docker ps -q -f name=${CNAME})" ]];
then
  docker container start ${CNAME}
fi

docker container exec -it ${CNAME} /entrypoint.sh
