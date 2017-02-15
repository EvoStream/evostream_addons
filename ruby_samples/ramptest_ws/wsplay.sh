#!/bin/sh
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
# Simulate WebSocket Playback
# Usage: wsplay <ip> <port> <streamname>
# Required: npm install -g wsnc
# Reference: https://github.com/substack/wsnc
#

IP="localhost"
if [ $# -gt 0 ]; then IP=$1; fi

PORT=8410
if [ $# -gt 1 ]; then PORT=$2; fi

STREAMNAME="mystream"
if [ $# -gt 2 ]; then STREAMNAME=$3; fi

wsnc ws://$IP:$PORT/$STREAMNAME?progressive > /dev/null
