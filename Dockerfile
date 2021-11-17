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

RUN /bin/bash -c "cd ~/catkin_ws/src; git clone https://github.com/tjdalsckd/panda_simulator_with_realsense.git panda_simulator;git clone https://github.com/justagist/franka_ros_interface.git;git clone https://github.com/ros-planning/panda_moveit_config.git -b melodic-devel;git clone https://github.com/ros-planning/moveit_tutorials.git -b master; git clone https://github.com/tjdalsckd/realsense_gazebo_plugin_smc.git; "
RUN apt-get update;
RUN apt-get install -y ros-noetic-panda-moveit-config
RUN apt-get install  -y ros-noetic-effort-controllers
RUN apt-get install -y  ros-noetic-franka-ros
RUN apt-get install -y  ros-noetic-rviz-visual-tools
RUN apt-get install -y  ros-noetic-moveit-visual-tools
RUN /bin/bash -c "cd ~;git clone https://github.com/orocos/orocos_kinematics_dynamics.git;cd  orocos_kinematics_dynamics/orocos_kdl; mkdir build ; cd  build ; cmake ..;make -j16;make install"
RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash; mkdir -p ~/catkin_ws/src; cd ~/catkin_ws; catkin_make'
RUN apt-get install -y terminator
RUN apt install -y  dirmngr gnupg apt-transport-https ca-certificates software-properties-common
RUN curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
RUN add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
RUN apt install -y  sublime-text
RUN /bin/bash -c "cd ~/catkin_ws/src;git clone https://github.com/tjdalsckd/franka_panda_description.git"
RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash; mkdir -p ~/catkin_ws/src; cd ~/catkin_ws; catkin_make'
RUN apt-get install -y python3-pip
RUN apt-get install -y  ros-noetic-moveit
RUN /bin/bash -c "pip install future;pip install numpy-quaternion; pip install -U numpy; pip install -U rospy_message_converter;"
RUN /bin/bash -c "cd /usr/include; ln -s eigen3/Eigen Eigen;"
RUN apt-get install -y python3-catkin-tools
RUN /bin/bash -c "rm -r ~/catkin_ws/*;mkdir -p ~/catkin_ws/src; cd ~/catkin_ws/src;    git clone  https://github.com/tjdalsckd/panda_simulator"
RUN /bin/bash -c "cd ~/catkin_ws/src; git clone https://github.com/ros-planning/moveit_calibration.git;  git clone https://github.com/tjdalsckd/realsense_gazebo_plugin_smc.git"
RUN /bin/bash -c "echo 'cd ~/catkin_ws/src/panda_simulator;'>> ~/.bashrc"
RUN apt-get install -y gedit
RUN apt-get install -y terminator





EXPOSE 80
EXPOSE 443
