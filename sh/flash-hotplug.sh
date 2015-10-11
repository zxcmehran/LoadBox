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
	echo "***[hotplug]*** Plugged in." | grep --color '.'
	cd $(dirname "$0")/..
	touch usbreadsucc
	
	mount $1 $DOWNLOAD_HOTPLUG
	ls $DOWNLOAD_HOTPLUG >/dev/null 2>&1
	
	if  [ "$?" -eq 0 ] && [ `stat -fc%t:%T "$DOWNLOAD_HOTPLUG"` != `stat -fc%t:%T "$DOWNLOAD_HOTPLUG/.."` ]; then
		if ps ax | grep -v grep | grep aria2c > /dev/null
		then
			echo "***[hotplug]*** Resuming downloads." | grep --color '.'
			scripts/startdownloads.py
		else
			echo "***[hotplug]*** Starting aria2c daemon." | grep --color '.'
			sh/start-aria2c.sh
		fi
	else
		echo "***[hotplug]*** Mounting failed." | grep --color '.'
	fi
fi
