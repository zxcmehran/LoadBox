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

. $(dirname "$0")/../configuration.sh
if [ "$DOWNLOAD_HOTPLUG" != "" ]; then
	cd $(dirname "$0")/..
	echo "***[hotplug]*** Plugged out. Killing processes that are using it's mount point." | grep --color '.'
	touch usbunreadsucc
	
	fuser -km $DOWNLOAD_HOTPLUG
	killall aria2c
	# wait till aria2c shutdown
	sleep 5
	umount $DOWNLOAD_HOTPLUG
fi
