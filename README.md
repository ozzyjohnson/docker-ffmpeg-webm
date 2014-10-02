## **ffmpeg-webm**

A executable container I built for launching transcoders which consume IP camera streams and transcode to webm for storage and monitoring. This images includes a default mount ```/data``` for writing the resulting video out to disk. In my use case, path is attached via NFS mount to an archival server. 

### Usage:

Ideally, start by setting some same defaults in the top of ```record.sh``` to minimize the number of required command line options. Hopefully, ffmpeg will merge a time/date segmenter at some point and I can do away with some of the ugliness here.

**record.sh**

    # Some sane defaults for the environment.
    DATE=`date +%Y-%m-%d`
    TIME=`date +%H-%M-%S`
    CAMERA_USER='user'
    CAMERA_PASS='pass'
    CAMERA_IP='10.10.10.1'
    CAMERA='mycamera'

    # Destination for recordings. Directors
    DEST_PATH="/data/"
    DEST_DIR=$CAMERA

    # Duration of segments in seconds.
    SEGMENT_DURATION='900'

**With Defualts:**

    docker run -it --rm -v /data:/mnt/data ffmpeg-webm

**With Options:**

    docker run -it --rm -v /data:/mnt/data ffmpeg-webm \
      -u camera_user \
      -p camera_password \
      -i camera_ip \
      -n camera_name \
      -s segment_duration \
      -d destination_dir \
      -v video_path 

[Image on Docker Hub](https://registry.hub.docker.com/u/ozzyjohnson/ffmpeg-webm/)

### FFMPEG Build Options:

#### ffmpeg

    --extra-libs=-ldl --enable-gpl --enable-libass --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264

#### others

    --enable-static / --disable-shared

#### **Sources:**

 - Yasm: git://github.com/yasm/yasm.git 
 - fdk-aac: git://github.com/mstorsjo/fdk-aac.git 
 - x264: git://git.videolan.org/x264.git 
 - libvpx: https://chromium.googlesource.com/webm/libvpx.git 
 - ffmpeg: git://source.ffmpeg.org/ffmpeg.git 
 - opus: git://git.opus-codec.org/opus.git

### Next:

 - record.sh could use a whole host of additional options and some usage text.
