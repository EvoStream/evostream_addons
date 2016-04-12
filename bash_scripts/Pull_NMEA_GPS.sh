#!/bin/sh

#####
#
# EvoStream Bash Scripts
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
#####

# This script tells the EMS to go and pull NMEA GPS metadata from
# a GPS receiver.  Giving it a "start" param will cause it to start collecting
# Calling this with no param will tell the EMS to stop collecting GPS metadata.

if [ $1 = "start" ]
then
        # Tell the EMS to start collecting meta data                           
        command="pullstream uri=nmea://192.168.25.1:11010 localstreamname=nmea"
        echo $command | nc localhost 1112
                                 
else                             
        #Remove the configs from above
        command="shutdownstream localstreamname=nmea permenantly=1"
        echo $command | nc localhost 1112
fi
