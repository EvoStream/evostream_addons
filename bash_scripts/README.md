# bash_scripts


## Overview

It is possible to access the [EMS APIs] (http://docs.evostream.com/ems_api_definition/table_of_contents) via a BASH script.  This is made possible using the "netcat" or "nc" tool.
Here's an example of how to do this:

> echo "**EMS_API_COMMAND**" | nc **EMS_Address** **1112**
>
> where:
> * **EMS_API_COMMAND** is the ASCII CLI format of the EMS Command that you wish to issue.
> * **EMS_Address** is the IP Address of the EMS instance.  If you are running the script on the same machine as EMS, **EMS_Address** shall be **localhost**.
> * You may use port **1112** or **1222**.  

Here's an example:

> echo "pullstream uri=rtmp://localhost/vod/NameOfFile.mp4 localstreamname=SomeTempName" | nc localhost 1112




## The Scripts

This folder provides a colleciton of BASH scripts that call the EMS API and control the streaming behavior of the video streaming during runtime.  These scripts can be used on embedded devices such as security cameras, action cams, or wearables, or can be used on servers to provide discrete functional scripts for server management.


### SimpleScripting.sh

This script contains sample netcat calls for accessing the EMS API.  You may use this as a template for building more complex scripts.

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
