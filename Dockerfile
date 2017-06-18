# powernex-env
# VERSION 1.0.0
#
# A docker image that contains the PowerNex building environment

FROM wild/archlinux-dlang
MAINTAINER Dan Printzell <me@vild.io>

RUN pacman -Syyu texinfo python guile2.0 ncurses expat xz --noprogressbar --noconfirm

RUN curl https://ci.vild.io/job/PowerNex/job/powernex-dmd/job/PowerNexCompiler/lastSuccessfulBuild/artifact/powernex-dmd -o /bin/powernex-dmd && chmod +x /usr/bin/powernex-dmd
RUN curl https://ci.vild.io/job/PowerNex/job/powernex-binutils/job/master/lastSuccessfulBuild/artifact/powernex-binutils.tar.xz | tar xkJ --no-same-owner -C /usr || true
