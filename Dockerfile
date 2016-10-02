# powernex-env
# VERSION 0.3.0
#
# A docker image that contains the PowerNex building environment

FROM wild/archlinux-dlang
MAINTAINER Dan Printzell <me@vild.io>
ENV TARGET x86_64-powernex
ENV PREFIX /opt/cc
ENV BINUTILS_VERSION binutils-2.26.1
ENV GDB_VERSION gdb-7.11

RUN pacman -S --noconfirm curl git
RUN curl -s http://ftp.gnu.org/gnu/binutils/$BINUTILS_VERSION.tar.gz | tar x --no-same-owner -zv

# Building patched binutils
RUN curl -s https://raw.githubusercontent.com/PowerNex/docker-powernex-env/master/$BINUTILS_VERSION.patch | patch -p0 -i -

RUN mkdir binutils-build && cd binutils-build && ../$BINUTILS_VERSION/configure --enable-gold --enable-plugins --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror && make -j && make install -j

RUN rm -rf $BINUTILS_VERSION binutils-build

# Building patched dmd
RUN git clone https://github.com/PowerNex/dmd.git --depth=1
RUN cd dmd && make -f powernex.mak && cp powernex-dmd /opt/cc/bin

# Building patched gdb
RUN curl -s http://ftp.gnu.org/gnu/gdb/$GDB_VERSION.tar.gz | tar x --no-same-owner -zv
RUN curl -s https://raw.githubusercontent.com/PowerNex/docker-powernex-env/master/$GDB_VERSION.patch | patch -p0 -i -

RUN mkdir gdb-build && cd gdb-build && ../$GDB_VERSION/configure --prefix="$PREFIX" --disable-nls && make -j && make install -j

RUN rm -rf $GDB_VERSION gdb-build
