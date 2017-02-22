#!/bin/sh
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

IPADDRESS=111.222.33.44
PORT=4000
./patchlua config.lua update url http://$IPADDRESS:$PORT/evowebservices/
