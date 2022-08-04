FROM jenkins/jenkins
USER root
LABEL author maikebing <mysticboy@live.com>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y &&  \
    apt-get  install git  scons  wget bzip2 \
    build-essential  libncurses-dev  cppcheck   \
    gcc-arm-none-eabi gdb-arm-none-eabi binutils-arm-none-eabi  qemu-system-arm  python -y &&  \
    apt-get clean -y 
RUN   curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && python2 get-pip.py &&  \
      pip install requests && rm get-pip.py 
RUN pkgs --help  && scons --help
RUN cd /tmp/ &&  wget -q https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/6-2016q4/gcc-arm-none-eabi-6_2-2016q4-20161216-linux.tar.bz2 && \
    tar xf ./gcc-arm-none-eabi-6_2-2016q4-20161216-linux.tar.bz2 && \
    mv gcc-arm-none-eabi-6_2-2016q4/ /opt/ && \
    rm ./gcc-arm-none-eabi-6_2-2016q4-20161216-linux.tar.bz2 && \
    /opt/gcc-arm-none-eabi-6_2-2016q4/bin/arm-none-eabi-gcc --version 
ENV RTT_EXEC_PATH /opt/gcc-arm-none-eabi-6_2-2016q4/bin/    
RUN git clone https://git.code.sf.net/p/stm32flash/code stm32flash-code && \
    cd /stm32flash-code && make && mv stm32flash /usr/bin/  && \
    cd / && rm /stm32flash-code  -rf && \
    stm32flash -h
    
RUN git clone https://gitee.com/RT-Thread-Mirror/env.git  /var/jenkins_home/.env/tools/scripts && \
    git clone https://gitee.com/RT-Thread-Mirror/packages.git  /var/jenkins_home/.env/packages/packages 
RUN  sed -i -e 's/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=y/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=n/g'  /var/jenkins_home/.env/tools/scripts/cmds/.config    
ENV  PATH=$PATH:/var/jenkins_home/.env/tools/scripts
USER jenkins

 
