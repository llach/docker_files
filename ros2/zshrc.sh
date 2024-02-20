# argcomplete for ros2 & colcon

source /opt/ros/humble/setup.zsh
echo "Sourced ROS 2 humble"

# Source the overlay workspace, if built
if [ -f $HOME/ws/install/setup.zsh ]
then
  source $HOME/ws/install/setup.zsh
  echo "Sourced workspace"
fi