FROM ubuntu:16.04
LABEL author maikebing <mysticboy@live.com>
ENV DEBIAN_FRONTEND noninteractive
ENV RTT_EXEC_PATH /opt/gcc-arm-none-eabi-6_2-2016q4/bin/
RUN apt-get update -y && \
    apt-get install git   wget bzip2 \
    build-essential  libncurses-dev  cppcheck   \
    gcc-arm-none-eabi gdb-arm-none-eabi binutils-arm-none-eabi  qemu-system-arm    \
    python3-pip  python3-requests  python-requests -y   \
    scons && \
    apt-get clean -y 
RUN cd /tmp/ &&  wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/6-2016q4/gcc-arm-none-eabi-6_2-2016q4-20161216-linux.tar.bz2 && \
    tar xf ./gcc-arm-none-eabi-6_2-2016q4-20161216-linux.tar.bz2 && \
    mv gcc-arm-none-eabi-6_2-2016q4/ /opt/ && \
    rm ./gcc-arm-none-eabi-6_2-2016q4-20161216-linux.tar.bz2 && \
    /opt/gcc-arm-none-eabi-6_2-2016q4/bin/arm-none-eabi-gcc --version 
RUN git clone https://git.code.sf.net/p/stm32flash/code stm32flash-code && \
    cd /stm32flash-code && make && mv stm32flash /usr/bin/  && \
    cd / && rm /stm32flash-code  -rf && \
    stm32flash -h
RUN git clone https://github.com/RT-Thread/env.git  /env/tools/scripts && \
    git clone https://github.com/RT-Thread/packages.git  /env/packages/packages 
ENV PATH $PATH:/env/tools/scripts 
RUN echo " if [ ! -f ~/.env ]; then ln  /env ~/.env  -s;fi"  >> /etc/bash.bashrc 
RUN sed -i -e 's/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=y/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=n/g'  /env/tools/scripts/cmds/.config

