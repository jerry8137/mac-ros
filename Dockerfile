FROM osrf/ros:noetic-desktop-full
MAINTAINER "Jerry Hou <jerry8137@gmail.com>"

# ENV PATH="/root/miniconda3/bin:${PATH}"
# ARG PATH="/root/miniconda3/bin:${PATH}"
ENV NVIDIA_VISIBLE_DEVICES \ 
${NVIDIA_VISIBLE_DEVICES:-all}

ENV NVIDIA_DRIVER_CAPABILITIES \
${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN apt-get -y update && apt-get install -y \
    iputils-ping \
    net-tools \
    wget \
    curl \
    build-essential \
    libgl1-mesa-dev \
    libglew-dev \
    libsdl2-dev \
    libsdl2-image-dev \
    libglm-dev \
    libfreetype6-dev \
    libglfw3-dev \
    libglfw3 \
    libglu1-mesa-dev \
    freeglut3-dev \
    pip \
    openssh-server \
    python3-tk

RUN export DISPLAY=":0.0"
ENTRYPOINT sudo service ssh restart && bash

ARG USERNAME=bob
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash"
RUN echo "source /opt/ros/noetic/setup.sh" >> ~/.bashrc
RUN echo "export PS1=\"(container) \$PS1\"" >> ~/.bashrc

RUN mkdir -p /home/bob/.ssh
RUN sudo sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sudo sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "root:root" | sudo chpasswd
RUN echo "${USER}:passwd" | sudo chpasswd
EXPOSE 22 

RUN pip install numpy imageio 
# RUN export ROS_MASTER_URI=http://localhost:11311
# RUN wget \
#     https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#     && mkdir /root/.conda \
#     && bash Miniconda3-latest-Linux-x86_64.sh -b \
#     && rm -f Miniconda3-latest-Linux-x86_64.sh 
# RUN conda --version
# RUN conda create --name pyenv python=3.8
# RUN conda init
# WORKDIR /
# ADD run.sh /run.sh
# RUN chmod 755 run.sh
# CMD ["/run.sh"]

