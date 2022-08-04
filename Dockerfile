FROM jenkins/jenkins
USER root
LABEL author maikebing <mysticboy@live.com>
ENV DEBIAN_FRONTEND noninteractive
ENV RTT_EXEC_PATH /opt/gcc-arm-none-eabi-6_2-2016q4/bin/
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free" > /etc/apt/sources.list && \
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
	echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free" >> /etc/apt/sources.list  && \
    curl -fsSL https://download.docker.com/linux/debian/gpg |   gpg --dearmor -o /etc/apt/keyrings/docker.gpg  && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian \
         $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update -y && apt-get install aptitude -y &&  \
    aptitude install git  aptitude  wget bzip2 \
    build-essential  libncurses-dev  cppcheck   \
    gcc-arm-none-eabi gdb-arm-none-eabi binutils-arm-none-eabi  qemu-system-arm  -y &&  \
    apt-get clean -y 
# RUN cd /tmp/ &&  wget -q https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/6-2016q4/gcc-arm-none-eabi-6_2-2016q4-20161216-linux.tar.bz2 && \
#     tar xf ./gcc-arm-none-eabi-6_2-2016q4-20161216-linux.tar.bz2 && \
#     mv gcc-arm-none-eabi-6_2-2016q4/ /opt/ && \
#     rm ./gcc-arm-none-eabi-6_2-2016q4-20161216-linux.tar.bz2 && \
#     /opt/gcc-arm-none-eabi-6_2-2016q4/bin/arm-none-eabi-gcc --version 
# RUN git clone https://git.code.sf.net/p/stm32flash/code stm32flash-code && \
#     cd /stm32flash-code && make && mv stm32flash /usr/bin/  && \
#     cd / && rm /stm32flash-code  -rf && \
#     stm32flash -h
RUN git clone https://gitee.com/RT-Thread-Mirror/env.git  /env/tools/scripts && \
    git clone https://gitee.com/RT-Thread-Mirror/packages.git  /env/packages/packages 
RUN  sed -i -e 's/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=y/CONFIG_SYS_PKGS_DOWNLOAD_ACCELERATE=n/g'  /env/tools/scripts/cmds/.config    
RUN apt-get update -y  
RUN  apt-get  install  python   -y  
RUN    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && python2 get-pip.py 
RUN   pip install requests
RUN apt-get install scons -y 
USER jenkins
ENV  PATH=$PATH:/var/jenkins_home/.env/tools/scripts
RUN  ln  /env /var/jenkins_home/.env  -s 
RUN  pkgs --help  && scons --help
     


 
