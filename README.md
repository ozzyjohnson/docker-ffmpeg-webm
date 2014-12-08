## **ffmpeg-webm**

**Built:** 

2014.12.07

An executable container I built for launching transcoders which consume IP camera streams and transcode to webm for storage and monitoring. This images includes a default mount ```/data``` for writing the resulting video out to disk. In my use case, this path is attached via NFS mount to an archival server.

I use this with a number of Cisco 5010, 2520, 2500 and Axis 3301 IP cameras. However, it should work just fine with any number of other IP cameras given the right ```video_path```. If you don't know this information, try searching the manufacturer's docs for "RTSP URL" or "VLC"


### Usage:

The script ```record.sh``` which is used as an ```ENTRYPOINT``` to this image is essential to the function of this image as built. You can see it along with the source Dockerfile over on GitHub.

[ozzyjohnson / docker-ffmpeg-webm](https://github.com/ozzyjohnson/docker-ffmpeg-webm)

Ideally, start by setting some same defaults in the top of ```record.sh``` to minimize the number of required command line options. Hopefully, ffmpeg will merge a time/date segmenter at some point and I can do away with some of the ugliness here.

**record.sh - default variables section**

    ...

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

    # Group of Pictures size.
    GOP_SIZE='12'

    # Output resolution.
    RECORDING_RESOLUTION='720x576'

    # Path to to the camera stream.
    VIDEO_PATH='/stream1'

    ...

**With Defaults:**

    docker run -it --rm -v /data:/mnt/data ffmpeg-webm

**With Options:**

    docker run -it --rm -v /data:/mnt/data ffmpeg-webm \
      -u camera_user \
      -p camera_password \
      -i camera_ip \
      -n camera_name \
      -s segment_duration \
      -d destination_dir \
      -v video_path \
      -r recording_resolution \
      -g gop_size \
      -o secondary_output
       
[Image on Docker Hub](https://registry.hub.docker.com/u/ozzyjohnson/ffmpeg-webm/)

### FFMPEG Build Options:

#### ffmpeg

    --extra-libs=-ldl --enable-gpl --enable-libass --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264

#### others

    --enable-static / --disable-shared

#### **Sources:**

 - Yasm: git://github.com/yasm/yasm.git 
 - x264: git://git.videolan.org/x264.git 
 - libvpx: https://chromium.googlesource.com/webm/libvpx.git 
 - ffmpeg: git://source.ffmpeg.org/ffmpeg.git 
 - opus: git://git.opus-codec.org/opus.git

### Next:

 - It looks like adding date/time functionality to ffmpeg could be a straightforward patch. I'll have to give it a try.
 - record.sh is a quick, direct conversion of the upstart job I'd been using previously, is there a better way? 
 - For my purposes, some built in camera templates would be nice, but I'm thinking I'll do this as a new image built from this rather than messing with the base.
