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
	while true && [ "$DOWNLOAD_DIR_NFS" != "" ]
	do
		REMOUNTED="0"
		ls "$DOWNLOAD_DIR_NFS" >/dev/null 2>&1
		AVAILABLE="$?"
		# To ensure that it's on a different mounted device
		if  [ `stat -fc%t:%T "$DOWNLOAD_DIR_NFS"` == `stat -fc%t:%T "$DOWNLOAD_DIR_NFS/.."` ]; then
			# IT'S NOT MOUNTED!
			AVAILABLE="1"
		fi
		
		if [ "$AVAILABLE" != "0" ]; then
			echo "***[network-mount]*** NFS not available. Killing aria2c daemon." | grep --color '.'
			REMOUNTED="1"
			killall aria2c
			umount "$DOWNLOAD_DIR_NFS"
			while [ "$AVAILABLE" != "0" ]
			do
				sleep $DIRECTNFS_RETRY_TIMEOUT
				echo "***[network-mount]*** NFS Remounting..." | grep --color '.'
				
				mount "$DOWNLOAD_DIR_NFS" >/dev/null 2>&1
				ls "$DOWNLOAD_DIR_NFS" >/dev/null 2>&1
				AVAILABLE="$?"
				if  [ `stat -fc%t:%T "$DOWNLOAD_DIR_NFS"` == `stat -fc%t:%T "$DOWNLOAD_DIR_NFS/.."` ]; then
					# IT'S NOT MOUNTED!
					AVAILABLE="1"
					umount "$DOWNLOAD_DIR_NFS"
				fi
			done
		else
			# If it's not running currently
			if ! ps ax | grep -v grep | grep aria2c > /dev/null
			then
				sh/start-aria2c.sh
			fi
		fi

		if [ "$REMOUNTED" == "1" ]; then
			echo "***[network-mount]*** NFS Remounted. Starting aria2c daemon." | grep --color '.'
			sh/start-aria2c.sh
		fi
		
		sleep $DIRECTNFS_CHECK_INTERVAL
	done
} &
