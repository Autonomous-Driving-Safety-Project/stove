FROM violinwang/stove:ubuntu18.04-cuda11.4-base

ARG username=ustc
ARG password=1234

ENV WORKUSER=${username}
ENV LANGUAGE="en_US.UTF-8"
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=Asia/Shanghai
ENV DISPLAY=:0
ENV GEOMETRY=1024x768x24
USER root

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    libgl1-mesa-glx libgl1-mesa-dri libglu1-mesa libegl1-mesa libxv1 x11vnc xvfb dbus-x11 xfce4-session xfce4-goodies xfwm4 xfdesktop4 xorg x11-xserver-utils curl && \
    rm -rf /var/lib/apt/lists/*
# install virtualgl
RUN curl -O https://nchc.dl.sourceforge.net/project/virtualgl/3.0.2/virtualgl_3.0.2_amd64.deb && \
    dpkg -i virtualgl_3.0.2_amd64.deb && \
    vglserver_config +glx +s +f +t && \
    rm virtualgl_3.0.2_amd64.deb
# Tidy up JWM for single app use case
RUN mkdir /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix
RUN echo '#!/bin/bash\nPASSWD=`cat /proc/sys/kernel/random/uuid | md5sum |cut -c 1-6`\necho "${WORKUSER}:${PASSWD}" | chpasswd\necho Password of $WORKUSER is $PASSWD\nXvfb $DISPLAY -screen 0 $GEOMETRY -cc 4 & \nsleep 0.5\nrm -f /tmp/.X0-lock\nsu - ustc -c "startxfce4 &"\nx11vnc -forever -nopw -q -bg' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

CMD /usr/local/bin/startup.sh && /usr/sbin/sshd -D
