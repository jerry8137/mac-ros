FROM osrf/ros:kinetic-desktop-full
MAINTAINER "Jerry Hou <jerry8137@gmail.com>"

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN apt-get -y update && apt-get install -y \
    iputils-ping \
    net-tools \
    wget \
    curl \
    ros-kinetic-tf2-sensor-msgs 

# ROS
RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash"
RUN echo "source /opt/ros/kinetic/setup.sh" >> /root/.bashrc
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc
RUN echo "export PS1=\"(container) \$PS1\"" >> /root/.bashrc
WORKDIR /root/catkin_ws/src

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 
RUN conda --version