# argcomplete for ros2 & colcon

function s {
  # Source the overlay workspace, if built
  if [ -f $HOME/ws/install/setup.zsh ]
  then
    source $HOME/ws/install/setup.zsh
    echo "Sourced workspace"
  fi

  # argcomplete for ros2 & colcon
  eval "$(register-python-argcomplete3 ros2)"
  eval "$(register-python-argcomplete3 colcon)"
}

function cb {
  prev_dir=$(pwd)

  cd $HOME/ws
  colcon build --symlink-install
  s
  cd $prev_dir
}

source /opt/ros/humble/setup.zsh
echo "Sourced ROS 2 humble"
s

alias rviz='ros2 run rviz2 rviz2'

