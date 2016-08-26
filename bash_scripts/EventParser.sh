#!/bin/bash

#####
#
# EvoStream Bash Scripts
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
#####

# This script can be used to receive EMS Event Notifications locally, parse them and 
# take action on them by implementing the parseEvent() function
# To use this script make sure that it has executable permissions and launch using:
#   ./EventParser.sh path_to_event_file.txt

# For ease of use, you should configure a file sink in the EMS config.lua file with the 
# following parameters:
# {
# 	type="file",
# 	filename="../logs/events.txt",
# 	format="json",
# 	appendTimestamp=false,
# 	appendInstance=false,
#	-- If you want to specify/limit the events you parse, you can add enabledEvents list
# 	-- enabledEvents=
# 	-- { -- list of events you want
# 	-- }
# },
#
# This configuration will cause the EMS to create a single file (in ../logs/) for all
# configured events, in json format, and the file will always be called "events.txt".
# This will allow you to predicably be able to call: ./EventParser.sh ../logs/events.txt

    parseEvent() {
        echo $1 | sed -e 's/,/\n/g'
        printf "\n--------------------\n" 
    }

    if [ $# -eq 0 ]; then
        echo "" 
        echo "USAGE: filesink.sh <filesink_filename>" 
        echo "NOTE:" 
        echo "  Please make sure that the output format of the file sink is" 
        echo "  set to JSON." 
        echo "  i.e.   format=\"json\"" 
    else
        export -f parseEvent
        tail -f -n +1 $1 | xargs -n1 -I {} bash -c 'parseEvent "$@"' _ {}
    fi
