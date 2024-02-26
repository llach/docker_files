ARG ROS_DISTRO=humble

FROM ros:${ROS_DISTRO}-ros-base

ENV ROS_DISTRO=${ROS_DISTRO}
SHELL ["/bin/bash", "-c"]

WORKDIR /home/ros

# Dev container arguments
ARG USERNAME=ros
ARG UID=1000
ARG GID=1000 

# Create new user and home directory
# hadolint ignore=DL3004
RUN groupadd -f --gid $GID $USERNAME \
 && useradd --uid ${UID} --gid ${GID} --create-home ${USERNAME} \
 && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
 && chmod 0440 /etc/sudoers.d/${USERNAME} \
 && chown -R ${UID}:${GID} /home/${USERNAME}

 # Set the ownership of the overlay workspace to the new user
RUN mkdir -p /home/ros/ws/src
RUN chown -R ${UID}:${GID} /home/ros/ws

RUN mkdir /home/ros/repos
RUN chown -R ${UID}:${GID} /home/ros/repos

# Install ROS dependencies
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && rosdep update
RUN sudo apt update && sudo apt upgrade -y
RUN sudo apt install ros-humble-usb-cam ros-humble-rviz2 ros-dev-tools ros-humble-ur-robot-driver ros-humble-ur-moveit-config ros-humble-moveit -y
RUN sudo apt install ros-humble-rqt-image-view ros-humble-ros2-control ros-humble-ros2-controllers ros-humble-rqt-joint-trajectory-controller -y

RUN sudo apt install vim python3-pip iputils-ping x11-apps mesa-utils -y
RUN sudo apt install ros-humble-tf-transformations ros-humble-rqt-console ros-humble-rqt-plot ros-humble-plotjuggler-ros ros-humble-plotjuggler -y
RUN sudo pip3 install transforms3d

RUN touch ~/.bashrc && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "alias rviz='ros2 run rviz2 rviz2 -d /home/ros/view_robot.rviz'" >> ~/.bashrc
RUN echo "alias b='colcon build --symlink-install'" >> ~/.bashrc
RUN echo "if [ -f $HOME/ws/install/setup.bash ]; then source ${HOME}/ws/install/setup.bash; fi" >> ~/.bashrc

# example configuration for ROS2 networking
RUN echo "# uncomment and specify your domain ID so others on the network can't see your nodes" >> ~/.bashrc
RUN echo "#export ROS_DOMAIN_ID=24" >> ~/.bashrc

RUN sudo usermod -a -G video ros
RUN sudo apt install -y zsh
USER ${USERNAME}

RUN sudo apt install -y ros-humble-rmw-cyclonedds-cpp
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# Set up the entrypoint
COPY entrypoint.sh /

SHELL ["/bin/zsh", "-c"]

RUN yes Y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

WORKDIR /home/ros/ws
ENTRYPOINT [ "/entrypoint.sh" ]