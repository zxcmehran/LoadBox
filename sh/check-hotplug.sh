#!/bin/bash

###
# LoadBox Downloader Toolset for Unix-Based Systems
# For more info:
# 	http://github.com/zxcmehran/LoadBox
#
#
# Developed by Mehran Ahadi
# http://mehran.ahadi.me/
#
# Licensed undet MIT (Expat) License
###

{
	# Check for device change
	PLUGFOUND="0"
	WAITING="0"
	while true
	do
		DEVICE=$(ls /dev/sd* | grep -o '/dev/sd[a-z]1' | sed -n '1 p') > /dev/null 2>&1
	
		if [ "$DEVICE" != "" ] && [ "$PLUGFOUND" == "0" ]; then
			PLUGFOUND="1"
			WAITING="0"
			#Found it
			sh/flash-hotplug.sh $DEVICE
		
		elif [ "$DEVICE" == "" ] && [ "$PLUGFOUND" == "1" ]; then
			PLUGFOUND="0"
			WAITING="0"
			#Lost it
			sh/flash-hotunplug.sh $DEVICE
		
		elif [ "$DEVICE" == "" ] && [ "$PLUGFOUND" == "0" ] && [ "$WAITING" == "0" ]; then
			echo "***[hotplug]*** Waiting for Hotplug event." | grep --color '.'
			WAITING="1"
		fi
	
		sleep $HOTPLUG_CHECK_INTERVAL
	done
} &
