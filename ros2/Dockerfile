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

USER ${USERNAME}

# Install ROS dependencies
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && rosdep update
RUN sudo apt update && sudo apt upgrade -y

RUN sudo apt install zsh curl -y
RUN yes Y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

COPY fastrps-upd-profile.xml /home/ros/
ENV  FASTRTPS_DEFAULT_PROFILES_FILE=/home/ros/fastrps-upd-profile.xml

# Set up the entrypoint
COPY entrypoint.sh /

SHELL ["/bin/zsh", "-c"]
WORKDIR /home/ros/ws
ENTRYPOINT [ "/entrypoint.sh" ]