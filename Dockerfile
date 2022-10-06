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

RUN mkdir -p /root/.ssh
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "root:root" | chpasswd
EXPOSE 22 
# ROS
# RUN mkdir -p /root/catkin_ws/src
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash"
RUN echo "source /opt/ros/noetic/setup.sh" >> /root/.bashrc
RUN echo "export PS1=\"(container) \$PS1\"" >> /root/.bashrc
WORKDIR /root/

RUN export DISPLAY=":0.0"
RUN pip install numpy imageio 
ENTRYPOINT service ssh restart && bash
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

