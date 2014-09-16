## **ffmpeg-webm**


A container I built for launching transcoders which consume IP camera streams and transcode to webm for storage and monitoring. FFMPEG and each codec is built from source.

#### ffmpeg

    --extra-libs=-ldl --enable-gpl --enable-libass --enable-libfdk-aac --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-nonfree

#### others

    --enable-static / --disable-shared

#### **Sources:**

 - Yasm: git://github.com/yasm/yasm.git 
 - fdk-aac: git://github.com/mstorsjo/fdk-aac.git 
 - x264: git://git.videolan.org/x264.git 
 - libvpx: https://chromium.googlesource.com/webm/libvpx.git 
 - ffmpeg: git://source.ffmpeg.org/ffmpeg.git 
 - opus: git://git.opus-codec.org/opus.git
