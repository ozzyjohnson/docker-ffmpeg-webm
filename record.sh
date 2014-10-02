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

# Group of Pictures size.
GOP_SIZE='12'

# Output resolution.
RECORDING_RESOLUTION='720x576'

# Path to to the camera stream.
VIDEO_PATH='/stream1'

# Help printer.

function help {
    echo "Usage: record.sh [OPTION]"
    echo "Launch FFMPEG against the specified RTSP stream and tee the result"
    echo "to disk | udp."
    echo " "
    echo "-u            camera username"
    echo "-p            camera password"
    echo "-i            camera IP address or hostname"
    echo "-n            aamera name, used when creating an output"
    echo "              directory"
    echo "-s            duration of recorded segments in seconds."
    echo "-d            top level destination directory. Recordings"
    echo "              will be placed in a <name> subdirectory."
    echo "-v            path to the camera RTSP stream. Typically"
    echo "              /video, /stream, /h264 or similar."
    echo "-r            recording resolution in the form '640x480'"
    echo "-g            GOP size used when recording."
    echo "-h            display this help and exit."
}

# Simple command line argument handling.
while getopts ':u:p:i:n:s:d:v:r:g:h' flag
    
do
    case $flag in
        u) CAMERA_USER=$OPTARG;;
        p) CAMERA_PASS=$OPTARG;;
        i) CAMERA_IP=$OPTARG;;
        n) CAMERA_NAME=$OPTARG;;
        s) SEGMENT_DURATION=$OPTARG;;
        d) DEST_DIR=$OPTARG;;
        v) VIDEO_PATH=$OPTARG;;
        r) RECORDING_RESOLUTION=$OPTARG;;
        g) GOP_SIZE=$OPTARG;;
        h) help; exit 0;;
        \?) help; exit 2;;
    esac
done

DEST=$DEST_PATH$DEST_DIR/

[ -d $DEST ] || mkdir -p $DEST

# Launch ffmpeg and generate two streams, one to disk
# and one accessible on port 8888 for use with ffserver
# or similar. It seems like there should be a cleaner 
# way to specify arguments for tee.

ffmpeg -i rtsp://$CAMERA_USER:$CAMERA_PASS@$CAMERA_IP$VIDEO_PATH \
  -c:v libvpx \
  -map 0 \
  -g $GOP_SIZE \
  -f tee \
  -s $RECORDING_RESOLUTION \
  "[f=segment:segment_time=${SEGMENT_DURATION}:reset_timestamps=1]${DEST}${DATE}_${TIME}_%05d.webm | [f=mpegts]udp://0.0.0.0:8888"

