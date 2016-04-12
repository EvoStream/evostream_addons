#!/bin/sh

#####
#
# EvoStream Bash Scripts
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
#####

# Socat can be used to bridge a stream into the EMS transcoder.
# This can be useful for pulling in non-H.264 streams that are very
# bursty in nature.  The socat buffer can help iron out that burstiness to 
# reduce packetloss at encode time.
# 
# This script assumes a Multicast UDP source 

# Params list for the script
#1. the target bitrate.
#2. The source multicast address
#3. The source multicast port
#4. The local ip
#5. The transcoding profile
#6. Target Stream Name
#7. Optional switch for send to file instead of executing

export AVCONV_DATADIR=/usr/share/evo-avconv/presets

if [ -z $7 ]
 then
	socat -u UDP-RECV:$3,bind=$2,ip-add-membership=$2:$4 -| \
evo-avconv -i - \
-acodec libfaac -b:a 32k \
-vcodec libx264 -b:v $1 \
-pre:v $5 \
-f flv -metadata streamName=$6 tcp://localhost:6666
 else
	echo "socat -u UDP-RECV:$3,bind=$2,ip-add-membership=$2:$4 -| \
evo-avconv -i - \
-acodec libfaac -b:a 32k \
-vcodec libx264 -b:v $1 \
-pre:v $5 \
-f flv -metadata streamName=$6 tcp://localhost:6666" > /tmp/$7
fi
