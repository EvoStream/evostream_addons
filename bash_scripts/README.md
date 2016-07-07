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

This script is useful for servers dedicated to transcoding a block of streams.  This script assumes a collection of multicast streams that it can pull, transcode, and then pass to the EMS for pushing to a seperate server (or servers) for final distribution.

#### A. Running the script

BlockTranscode.sh [push]
- push : Optional parameter.  If "push" is present, the transcoded streams shall be pushed to the a separate server.

#### B. Customizing / Configuring the script.

If you're not familiar with BASH scripting, the following sections provides tips on how to customize this script.  


##### i. Multicast IP List

In this section, an array "iplist" is initialized by adding the Multicast IP address from where EMS shall pull streams from for transcoding.

Currently, the script has 5 Multicast IPs defined:

> iplist[Stream1]=225.0.0.1
 
> iplist[Stream2]=225.0.0.2
 
> iplist[Stream3]=225.0.0.3
 
> iplist[Stream4]=225.0.0.4
 
> iplist[Stream5]=225.0.0.5

If you're happy with the pre-defined list of Multicast IPs, you may leave this section unmodified.
If you want to change the contents of the list:
- Change the Multicast IP of an existing entry.
- Delete or comment out an entry to reduce.  (To comment out, prefix the line with a #)
- Add a new entry.  The easiest way to add a new entry is to copy and past the last entry, then change the index and Multicast IP address.

> ex. 
> 
> iplist[Stream1]=225.0.0.1

> iplist[Stream2]=225.0.0.2

> iplist[Stream3]=225.0.0.3

> iplist[Stream4]=225.0.0.4

> iplist[Stream5]=225.0.0.5

> iplist[**Stream6**]=**225.0.0.8**
  

##### ii. EMS API Parameters 

This section contains the declaration of the EMS API parameters that shall be used for the transcode and push operation.
Please refer to the EMS API documentation for the transcode and pushstream commands for more details.

You may change the parameter values to your desired settings.

If you wish to remove a parameter, you may delete or comment it out.  However, please make sure that you also remove the corresponding parameter in the API call  (This is covered in the next section.)

If you wish to add a new parameter, make sure that it is also reflected in the API call.  (See next section.)


##### iii. Transcode and Push 

This section of the script contains a loop construct.  This loop iterates through each Multicast IP defined in the iplist array.  For each Multicast IP, the loop will issue a transcode command.

The transcode command is defined as:

>	command="transcode source=udp://**$source**:**$sourceip** destinations=**$streamname** groupname=**$groupname** videoBitrates=**$vbitrate** videoAdvancedParamsProfiles=**$profile** audioBitrates=**$abitrate**"

If the script was called with the "push" parameter, the pushstream command will be executed.  The pushstream command is defined as:

>	pcommand="pushstream localstreamname=**$streamname** uri=rtmp://**$broadcaster**/live targetstreamname=**$streamname**"

Notice how each parameter defined in the previous section appears in the command.  If you added or removed a parameter, you should update the command to reflect the changes.


### BulkMulticastTSPull.sh 

This script collects a bunch of TS Multicast streams and pushes them to a destination server. This script assumes a collection of multicast streams that it will pull and then push to a seperate server (or servers) for final distribution

### Ambarella.A9-EMS-StartStreaming.sh

This script activates the streaming engine on an A9-Based Camera and starts EMS The Ambarella A9 SoC has both an RTOS which runs on the bare metal of the  device/camera as well as a linux kernel which runs as a process in the RTOS. The EMS and this script will be run within the "virtualized" linux kernel

### Pull_NMEA_GPS.sh

This script tells the EMS to go and pull NMEA GPS metadata from a GPS receiver.  Giving it a "start" param will cause it to start collecting. Calling this with no param will tell the EMS to stop collecting GPS metadata.

### socatTranscodeProxy.sh

Socat can be used to bridge a stream into the EMS transcoder. This can be useful for pulling in non-H.264 streams that are very bursty in nature.  The socat buffer can help iron out that burstiness to reduce packetloss at encode time.
