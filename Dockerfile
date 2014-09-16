FROM debian:jessie

MAINTAINER Ozzy Johnson <ozzy.johnson@gmail.com>
 
RUN apt-get -y update && apt-get install -y \
    git-core \
    autoconf \
    automake \
    build-essential \
    libass-dev \
    libgpac-dev \
    libtheora-dev \
    libtool \
    libvorbis-dev \
    pkg-config \
    texi2html \
    zlib1g-dev \
    libmp3lame-dev
 
# Avoid those ugly Dialog errors from debconf.
ENV DEBIAN_FRONTEND noninteractive


# CLONING:

WORKDIR /tmp

RUN git clone git://github.com/yasm/yasm.git
RUN git clone git://github.com/mstorsjo/fdk-aac.git
RUN git clone git://git.videolan.org/x264.git
RUN git clone https://chromium.googlesource.com/webm/libvpx.git
RUN git clone git://source.ffmpeg.org/ffmpeg.git
RUN git clone git://git.opus-codec.org/opus.git

# COMPILING:

## Yasm

WORKDIR /tmp/yasm
RUN ./autogen.sh
RUN ./configure
RUN make -j`getconf _NPROCESSORS_ONLN`
RUN make install
RUN make distclean

## x264

WORKDIR /tmp/x264
RUN ./configure --enable-static --disable-opencl
RUN make -j`getconf _NPROCESSORS_ONLN`
RUN make install
RUN make distclean

## fdk-aac

WORKDIR /tmp/fdk-aac
RUN autoreconf -fiv
RUN ./configure --disable-shared
RUN make -j`getconf _NPROCESSORS_ONLN`
RUN make install
RUN make distclean

## libopus

WORKDIR /tmp/opus
RUN ./autogen.sh
RUN ./configure --disable-shared
RUN make -j`getconf _NPROCESSORS_ONLN`
RUN make install
RUN make distclean

## libvpx

WORKDIR /tmp/libvpx
RUN ./configure --disable-shared
RUN make -j`getconf _NPROCESSORS_ONLN`
RUN make install
RUN make clean

## ffmpeg

WORKDIR /tmp/ffmpeg
RUN ./configure --extra-libs=-ldl --enable-gpl --enable-libass --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-nonfree
RUN make -j`getconf _NPROCESSORS_ONLN`
RUN make install
RUN make distclean

