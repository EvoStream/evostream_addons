# bash_scripts


## Overview

This folder provides a colleciton of BASH scripts that call the EMS API and control the streaming behavior of the video streaming during runtime.  These scripts can be used on embedded devices such as security cameras, action cams, or wearables, or can be used on servers to provide discrete functional scripts for server management.


## The Scripts

### SimpleScripting.sh

This script provides some examples of some basic bash scripting techniques

### BlockTranscode.sh

This script is useful for servers dedicated to transcoding a block of streams.  This script assumes a collection of multicast streams that it can pull, transcode, and then pass to the EMS for pushing to a seperate server (or servers) for final distribution

### BulkMulticastTSPull.sh 

This script collects a bunch of TS Multicast streams and pushes them to a destination server. This script assumes a collection of multicast streams that it will pull and then push to a seperate server (or servers) for final distribution

### Ambarella.A9-EMS-StartStreaming.sh

This script activates the streaming engine on an A9-Based Camera and starts EMS The Ambarella A9 SoC has both an RTOS which runs on the bare metal of the  device/camera as well as a linux kernel which runs as a process in the RTOS. The EMS and this script will be run within the "virtualized" linux kernel

### Pull_NMEA_GPS.sh

This script tells the EMS to go and pull NMEA GPS metadata from a GPS receiver.  Giving it a "start" param will cause it to start collecting. Calling this with no param will tell the EMS to stop collecting GPS metadata.

### socatTranscodeProxy.sh

Socat can be used to bridge a stream into the EMS transcoder. This can be useful for pulling in non-H.264 streams that are very bursty in nature.  The socat buffer can help iron out that burstiness to reduce packetloss at encode time.