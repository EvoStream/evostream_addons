#!/bin/bash

#####
#
# EvoStream Bash Scripts
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
#####

# This script provides some examples of some basic bash scripting techniques

# Create an HLS Stream
echo "createhlsstream localStreamNames=SomeTempName targetFolder=/var/www/ groupName=NameYouWantForStream " | nc localhost 1112
# Create a DASH Stream
echo "createdashstream localstreamnames=evo groupname=NameYouWantForStream playlisttype=rolling targetfolder=/var/www/" | nc localhost 1112
# Issue a Pull Stream Command
echo "pullstream uri=rtmp://localhost/vod/NameOfFile.mp4 localstreamname=SomeTempName" | nc localhost 1112

echo "EMS now configured"
