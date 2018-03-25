# powernex-env
# VERSION 1.0.0
#
# A docker image that contains the PowerNex building environment

FROM wild/archlinux-dlang
MAINTAINER Dan Printzell <me@vild.io>

RUN pacman -Sy ninja xorriso grub --noprogressbar --noconfirm

RUN curl https://raw.githubusercontent.com/PowerNex/PowerNex/master/toolchainManager.d -o /tmp/toolchainManager.d && chmod +x /tmp/toolchainManager.d
RUN mkdir build; ln -s /usr/ build/cc
RUN /tmp/toolchainManager.d --noconfirm