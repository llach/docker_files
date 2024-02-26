#!/bin/bash

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"
CNAME=rs-ros

# container neither running nor stopped? → create
if [[ -z "$(docker ps -a -q -f name=${CNAME})" ]]
then
echo "creating container"
docker create -i -t --name ${CNAME} \
                --net=host \
                --privileged  \
                --device-cgroup-rule "c 81:* rmw" \
                --device-cgroup-rule "c 189:* rmw" \
                ${REPOSITORY_NAME} bash
fi

# container not running? → start
if [[ -z "$(docker ps -q -f name=${CNAME})" ]];
then
  docker container start -i --attach ${CNAME}
fi

docker container exec -it ${CNAME} bash
