# Google mirrors are very fast.
FROM google/debian:wheezy

MAINTAINER Ozzy Johnson <ozzy.johnson@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Update and install minimal.
RUN \
  apt-get update \
            --quiet && \
  apt-get install \ 
            --yes \
            --no-install-recommends \
            --no-install-suggests \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    git-core \
    libass-dev \
    libgpac-dev \
    libtheora-dev \
    libtool \
    libvorbis-dev \
    pkg-config \
    python-minimal \
    texi2html \
    zlib1g-dev 

# Clean up packages.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# CLONING:

WORKDIR /tmp
RUN git clone git://github.com/yasm/yasm.git
RUN git clone git://git.videolan.org/x264.git
RUN git clone https://chromium.googlesource.com/webm/libvpx
RUN git clone git://source.ffmpeg.org/ffmpeg.git
RUN git clone git://git.opus-codec.org/opus.git

# COMPILING:

## Yasm

WORKDIR /tmp/yasm
RUN ./autogen.sh &&\
    ./configure && \
    make -j`getconf _NPROCESSORS_ONLN` && \
    make install && \
    make distclean

## x264

WORKDIR /tmp/x264
RUN ./configure --enable-static --disable-opencl && \
    make -j`getconf _NPROCESSORS_ONLN` && \
    make install &&\
    make distclean

## libopus

WORKDIR /tmp/opus
RUN ./autogen.sh && \
    ./configure --disable-shared && \
    make -j`getconf _NPROCESSORS_ONLN` && \
    make install && \
    make distclean

## libvpx

WORKDIR /tmp/libvpx
RUN ./configure --disable-shared && \
    make -j`getconf _NPROCESSORS_ONLN` && \
    make install &&\
    make clean

## ffmpeg

WORKDIR /tmp/ffmpeg
RUN ./configure \
        --extra-libs=-ldl \
        --enable-gpl \
        --enable-libass \
        --enable-libopus \
        --enable-libtheora \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libx264 && \
    make -j`getconf _NPROCESSORS_ONLN` && \
    make install && \
    make distclean

# Access to second stream for consumption by ffserver or similar.
EXPOSE 8888

# Wrapper for ffmpeg to keep the container launch simple.
ADD record.sh /record.sh

# A volume for video output.
VOLUME ["/data"]

ENTRYPOINT ["/bin/bash", "/record.sh"]
