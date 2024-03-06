#!/bin/zsh
# Basic entrypoint for ROS / Colcon Docker containers

# Source ROS 2
source /opt/ros/${ROS_DISTRO}/setup.zsh
echo "Sourced ROS 2 ${ROS_DISTRO}"

# Source the overlay workspace, if built
if [ -f $HOME/ws/install/setup.zsh ]
then
  source $HOME/ws/install/setup.zsh
  echo "Sourced workspace"
fi

cd $HOME/ws
exec zsh