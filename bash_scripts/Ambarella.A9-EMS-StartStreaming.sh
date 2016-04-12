#!/bin/bash

#####
#
# EvoStream Bash Scripts
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
#####

# This script activates the streaming engine on an A9-Based Camera and starts EMS
# The Ambarella A9 SoC has both an RTOS which runs on the bare metal of the 
# device/camera as well as a linux kernel which runs as a process in the RTOS
# The EMS and this script will be run within the "virtualized" linux kernel


# Use either 1 or the first param as the token for the messages sent to the camera
token="1"
if [ $# -eq 1 ]
then
	token=$1
fi

echo "Token = $token"


## EMS Process Mgmt ##
# Clear out any currently running EMS. 
killall -9 evostreamms

# Clears the config for the EMS to get a "fresh start". Not necessary and can be removed.
rm ../config/pushPullSetup.xml

# Restart the EMS. This assumes this script is being run in the same directory as the EMS
./run_daemon_ems.sh



## Start the camera streaming. ##
# Setup fifo so that we can send multiple messages using the same connection
outpipe=/tmp/out
rm -f $outpipe
mkfifo $outpipe
nc 127.0.0.1 7878 <$outpipe &
#hack to keep the nc session open
sleep 999999 > $outpipe & 

# Init message
echo "{\"msg_id\" : 257,\"token\" : 0}" > $outpipe
sleep 2
echo ""

# Start Session
echo "{\"msg_id\" : 3,\"token\" : $token}" > $outpipe 
sleep 1
echo ""

# Set RTSP Out
echo "{\"msg_id\" : 2,\"param\" : \"rtsp\",\"token\" : $token,\"type\" : \"stream_out_type\"}" > $outpipe   
sleep 1
echo ""

# Set PAL
echo "{\"msg_id\" : 2,\"param\" : \"PAL\",\"token\" : $token,\"type\" : \"video_standard\"}" > $outpipe
sleep 1
echo ""

# Start Video
echo "{\"msg_id\" : 259,\"param\" : \"none_force\",\"token\" : $token}" > $outpipe

echo "Camera should now be streaming"


## EMS Streaming ##
# Now we can tell the EMS to get the source stream we just started
echo "pullstream uri=rtsp://localhost/live localstreamname=evo forcetcp=0" | nc localhost 1112

echo "Good to go!"

