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

. "$(dirname "$0")"/../configuration.sh
if [ "$DOWNLOAD_HOTPLUG" != "" ]; then
	echo "***[hotplug]*** Plugged in." | grep --color '.'
	cd "$(dirname "$0")"/..
	touch usbreadsucc

	echo "***[hotplug]*** Trying to mount as FAT32/NTFS" | grep --color '.'
	mount "$1" "$DOWNLOAD_HOTPLUG" -o uid=$(id -u $ARIA2C_WORKING_USER),gid=$(id -g $ARIA2C_WORKING_USER),utf8,dmask=027,fmask=137
	
	if  [ "$?" -ne 0 ]
	then 
		echo "***[hotplug]*** No Luck. Trying to mount as EXT3/4" | grep --color '.'
		# If it's ext4, uid and gid would be obsolete.
		mount "$1" "$DOWNLOAD_HOTPLUG"
	fi

	ls "$DOWNLOAD_HOTPLUG" >/dev/null 2>&1
	
	if  [ "$?" -eq 0 ] && mountpoint -q -- "$DOWNLOAD_HOTPLUG"; then
		echo "***[hotplug]*** Mounting done." | grep --color '.'

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
