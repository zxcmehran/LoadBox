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
	. $(dirname "$0")/../configuration.sh

	cd $(dirname "$0")/..

	echo "Starting aria2c daemon." | grep --color '.'

	if [ "$CERTFILE" == "" ]; then
		sudo -u $ARIA2C_WORKING_USER aria2c --conf=aria2.conf --dir=$DOWNLOAD_DIR --on-download-complete=sh/upload.sh 
	else
		if [ "$KEYFILE" == "" ]; then
			sudo -u $ARIA2C_WORKING_USER aria2c --conf=aria2.conf --dir=$DOWNLOAD_DIR --on-download-complete=sh/upload.sh --rpc-certificate=$CERTFILE --rpc-secure 
		else
			sudo -u $ARIA2C_WORKING_USER aria2c --conf=aria2.conf --dir=$DOWNLOAD_DIR --on-download-complete=sh/upload.sh --rpc-certificate=$CERTFILE --rpc-private-key=$KEYFILE --rpc-secure 
		fi
	fi

	echo "Error: aria2c Daemon stopped!" | grep --color '.'
} &
