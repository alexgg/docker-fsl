FROM ubuntu:xenial

MAINTAINER Alex Gonzalez <alex.gonzalez@digi.com>

# Non-interactive debconf package configuration
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu and Install Yocto Proyect Quick Start and FSL dependencies
RUN apt-get update && apt-get install -y locales gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev xterm cpio curl python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa dos2unix vim sudo && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set bash as default shell
RUN echo "dash dash/sh boolean false" | debconf-set-selections - && dpkg-reconfigure dash

# Set the locale
RUN locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

# Install repo
RUN curl -o /usr/local/bin/repo http://commondatastorage.googleapis.com/git-repo-downloads/repo && chmod a+x /usr/local/bin/repo

# User management
RUN groupadd -g 1000 fsl && useradd -u 1000 -g 1000 -ms /bin/bash fsl
RUN echo "fsl ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install FSL community BSP
ARG FSL_BRANCH="master"
ARG FSL_INSTALL_PATH="/usr/local/fsl"

RUN install -o 1000 -g 1000 -d $FSL_INSTALL_PATH
RUN install -o 1000 -g 1000 -d $FSL_INSTALL_PATH/build
WORKDIR $FSL_INSTALL_PATH
USER fsl

RUN repo init -u https://github.com/Freescale/fsl-community-bsp-platform -b $FSL_BRANCH && repo sync -j4 --no-repo-verify

ENV FSL_INSTALL_PATH=$FSL_INSTALL_PATH
RUN echo "echo Welcome to FSL community BSP $FSL_BRANCH docker image!" >> /home/fsl/.bashrc
