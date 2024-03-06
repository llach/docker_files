ARG ROS_DISTRO=humble

FROM ros2_dev:${ROS_DISTRO}
ENV ROS_DISTRO=${ROS_DISTRO}

ARG USERNAME=ros
USER ${USERNAME}

RUN sudo apt install -y zsh
RUN yes Y | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set up the entrypoint
COPY zshrc.sh /home/${USERNAME}/z
RUN cat /home/${USERNAME}/z >> /home/${USERNAME}/.zshrc && rm /home/${USERNAME}/z

SHELL ["/bin/zsh"]
CMD ["/bin/zsh"]