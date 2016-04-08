FROM wild/archlinux-dlang
MAINTAINER Dan Printzell <me@vild.io>
ENV TARGET32 i686-powernex
ENV TARGET64 x86_64-powernex
ENV PREFIX /opt/cc
ENV BINUTILS_VERSION binutils-2.26

RUN pacman -S --noconfirm curl git
RUN curl -s http://ftp.gnu.org/gnu/binutils/$BINUTILS_VERSION.tar.gz | tar x --no-same-owner -zv

# Building patched binutils
ADD $BINUTILS_VERSION.patch ./$BINUTILS_VER.patch
RUN patch -p0 -i $BINUTILS_VER.patch

RUN mkdir binutils-build && cd binutils-build && ../$BINUTILS_VERSION/configure --enable-gold --enable-plugins --target=$TARGET32 --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror && make -j && make install -j
RUN mkdir binutils-build64 && cd binutils-build64 && ../$BINUTILS_VERSION/configure --enable-gold --enable-plugins --target=$TARGET64 --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror && make -j && make install -j

RUN rm -rf $BINUTILS_VERSION binutils-build binutils-build64

# Building patched dmd
RUN git clone https://github.com/PowerNex/dmd.git --depth=1
RUN cd dmd && make -f powernex.mak && cp powernex-dmd /opt/cc/bin