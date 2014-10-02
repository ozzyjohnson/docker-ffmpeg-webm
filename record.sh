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

# Simple command line argument handling.
while getopts ':u:p:i:n:s:d:' flag
    
do
    case $flag in
        u) CAMERA_USER=$OPTARG;;
        p) CAMERA_PASS=$OPTARG;;
        i) CAMERA_IP=$OPTARG;;
        n) CAMERA_NAME=$OPTARG;;
        s) SEGMENT_DURATION=$OPTARG;;
        d) DEST_DIR=$OPTARG;;
    esac
done

DEST=$DEST_PATH$DEST_DIR/

[ -d $DEST ] || mkdir -p $DEST

# Launch ffmpeg and generate two streams, one to disk
# and one accessible on port 8888 for use with ffserver
# or similar. It seems like there should be a cleaner 
# way to specify arguments for tee.

ffmpeg -i rtsp://$CAMERA_USER:$CAMERA_PASS@$CAMERA_IP/stream1 \
  -c:v libvpx \
  -map 0 \
  -g 12 \
  -f tee \
  -s 720x576 \
  "[f=segment:segment_time=900:reset_timestamps=1]${DEST}${DATE}_${TIME}_%05d.webm | [f=mpegts]udp://0.0.0.0:8888"

