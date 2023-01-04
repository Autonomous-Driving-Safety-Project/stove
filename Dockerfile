FROM nvidia/cuda:11.4.2-cudnn8-runtime-ubuntu18.04

ARG username=ustc
ARG password=1234

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && apt-get update
RUN apt-get install -y sudo curl wget git libopenmpi-dev openssh-server
RUN useradd --create-home --no-log-init --shell /bin/bash ${username} \
    && adduser ${username} sudo \
    && echo "${username}:${password}" | chpasswd
RUN mkdir /var/run/sshd
EXPOSE 22
WORKDIR /home/${username}
USER ${username}
RUN curl -O https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh \
    && sh Miniconda3-py39_4.12.0-Linux-x86_64.sh -b -p ~/.miniconda3 \
    && rm Miniconda3-py39_4.12.0-Linux-x86_64.sh \
    && ~/.miniconda3/bin/conda init
WORKDIR /root
USER root
ENV WORKUSER=${username}
CMD ["/bin/bash", "-c", "PASSWD=`cat /proc/sys/kernel/random/uuid | md5sum |cut -c 1-6` && echo Password of $WORKUSER is $PASSWD && echo \"${WORKUSER}:${PASSWD}\" | chpasswd && /usr/sbin/sshd -D"]
