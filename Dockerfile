FROM violinwang/stove:ubuntu20.04-cuda11.5-vnc-xfce

ARG username=ustc
ARG password=1234

ENV ROSDISTRO_INDEX_URL=https://mirrors.tuna.tsinghua.edu.cn/rosdistro/index-v4.yaml

USER root

RUN mkdir -p /etc/apt/sources.list.d/ && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ focal main">/etc/apt/sources.list.d/ros-latest.list && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get update && \
    apt-get install -y ros-noetic-desktop && \
    echo "source /opt/ros/noetic/setup.bash" >> /home/${username}/.bashrc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN apt-get update && \
    apt-get install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential && \
    mkdir -p /etc/ros/rosdep/sources.list.d/ && \
    curl -o /etc/ros/rosdep/sources.list.d/20-default.list https://mirrors.tuna.tsinghua.edu.cn/github-raw/ros/rosdistro/master/rosdep/sources.list.d/20-default.list && \
    rosdep update && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD /usr/local/bin/startup.sh && /usr/sbin/sshd -D
