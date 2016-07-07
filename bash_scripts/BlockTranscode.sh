#!/bin/sh

#####
#
# EvoStream Bash Scripts
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
#####

# This script is useful for servers dedicated to transcoding a block of 
# streams.  This script assumes a collection of multicast streams
# that it can pull, transcode, and then pass to the EMS for pushing
# to a seperate server (or servers) for final distribution


#Build a list of multicast streams to pull
declare -A iplist
#iplist[   ]=
iplist[Stream1]=225.0.0.1
iplist[Stream2]=225.0.0.2
iplist[Stream3]=225.0.0.3
iplist[Stream4]=225.0.0.4
iplist[Stream5]=225.0.0.5

#push params
broadcaster=192.168.5.5

#Build the transcode parameters
sourceport=1234
profile=veryfast
vbitrate=750k
abitrate=64k
groupname=GroupTranscode

#kill any existing transcode jobs
echo "removeConfig groupname=$groupname" | nc localhost 1112

#loop over ip list and start the transcode jobs.
for i in "${!iplist[@]}" 
do
	streamname=$i
	source=${iplist[$i]}
	echo Starting transcode for stream $streamname at address $source
	command="transcode source=udp://$source:$sourceport destinations=$streamname groupname=$groupname videoBitrates=$vbitrate videoAdvancedParamsProfiles=$profile audioBitrates=$abitrate"
	
	echo $command
	echo $command | nc localhost 1112
	
	#If the push param is present, push the local streams to the broadcast server
	if [ $1 == "push" ]; then
		pcommand="pushstream localstreamname=$streamname uri=rtmp://$broadcaster/live targetstreamname=$streamname"
		echo $pcommand
		echo $pcommand | nc localhost 1112
	fi
	
done


