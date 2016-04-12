#!/bin/sh

#####
#
# EvoStream Bash Scripts
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
#####

# this script collects a bunch of TS Multicast streams and pushes 
# them to a destination server. This script assumes a collection of 
# multicast streams that it will pull and then push
# to a seperate server (or servers) for final distribution

#

#Build a list of multicast streams to pull
declare -A iplist
#iplist[   ]=
iplist[Stream1]=225.1.1.1
iplist[Stream2]=225.1.1.2
iplist[Stream3]=225.1.1.3
iplist[Stream4]=225.1.1.4

sourceport=1234

#push params
broadcaster=192.168.5.5

#loop over ip list and start the pulls
for i in "${!iplist[@]}" 
do
	streamname=$i
	source=${iplist[$i]}
	echo pull stream $streamname at address $source
	command=“pullstream uri=dmpegtsudp://$source:$sourceport localstreamname=$streamname”
	
	echo $command
	echo $command | nc localhost 1112
	
	#If the push param is present, push the local streams to the broadcast server
	if [ $1 == "push" ]; then
		pcommand="pushstream localstreamname=$streamname uri=rtmp://$broadcaster/live targetstreamname=$streamname"
		echo $pcommand
		echo $pcommand | nc localhost 1112
	fi
	
done
