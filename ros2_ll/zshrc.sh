# argcomplete for ros2 & colcon

source /opt/ros/humble/setup.zsh
echo "Sourced ROS 2 humble"

# Source the overlay workspace, if built
if [ -f $HOME/ws/install/setup.zsh ]
then
  source $HOME/ws/install/setup.zsh
  echo "Sourced workspace"
fi

# argcomplete for ros2 & colcon
eval "$(register-python-argcomplete3 ros2)"
eval "$(register-python-argcomplete3 colcon)"
