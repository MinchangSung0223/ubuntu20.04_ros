FROM nvidia/cudagl:11.2.1-devel-ubuntu20.04
MAINTAINER minchang <tjdalsckd@gmail.com>
RUN apt-get update &&  apt-get install -y -qq --no-install-recommends \
    libgl1 \
    libxext6 \ 
    libx11-6 \
   && rm -rf /var/lib/apt/lists/*


ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
ARG ssh_prv_key
ARG ssh_pub_key
RUN  apt-get -yq update && \
     apt-get -yqq install ssh
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y wget
RUN apt-get install -y sudo curl
RUN sudo apt update && sudo apt install -y curl gnupg2 lsb-release
RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN sudo apt update
ENV TZ=Europe/Minsk
ARG DEBIAN_FRONTEND=noninteractive  

RUN DEBIAN_FRONTEND=noninteractive  apt-get install -yq --no-install-recommends ros-noetic-desktop-full
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN echo "source /root/catkin_ws/devel/setup.bash" >> ~/.bashrc

RUN sudo apt install -y  python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
RUN sudo apt install -y  python3-rosdep
RUN sudo rosdep init
RUN rosdep update
RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash; mkdir -p ~/catkin_ws/src; cd ~/catkin_ws; catkin_make'







EXPOSE 80
EXPOSE 443
