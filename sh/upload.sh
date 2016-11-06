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
cd "$(dirname "$0")"/..

# DIR would be mount point
# SUBDIR would be the path relative to mount point WITH BEGINNING SLASH.
# Example:
# DIR1="/media/NetworkStorage"
# SUBDIR1="/Downloads"
#
# You can define two locations on two network devices. DIR2 will be the fallback when DIR1 is not available.
# Add DIR1 to fstab and set as automount.

DIR1="$NETWORK_DIR1"
SUBDIR1="$NETWORK_SUBDIR1"

DIR2="$NETWORK_DIR2"
SUBDIR2="$NETWORK_SUBDIR2"

# Get downloaded file(s) address on disk
FNAME="$(./scripts/getfile.py "$1")"
ERR="$?"
if [ "$ERR" -ne 0 ]; then
	printf "\n%s" "$FNAME"
	printf "\nInvalid response. Error code %s\n" "$ERR"
	exit
fi

if [ "$IFTTT_MAKER_KEY" != "" ]; then
	FBASENAME="$(basename "$FNAME")"
	curl -X POST -H "Content-Type: application/json" -d "{\"value1\":\"Downloading $FBASENAME completed.\"}" https://maker.ifttt.com/trigger/$IFTTT_MAKER_EVENT/with/key/$IFTTT_MAKER_KEY
fi

if [ "$NETWORK_SYNC" -eq "0" ]; then
	printf "\n"
	printf "***[upload]*** Uploading is disabled. Skipping.\n" | grep --color '.'
	exit 0
fi

TARGETDIR="$DIR1"
TARGETSUBDIR="$SUBDIR1"

while true
do
	mount "$TARGETDIR" >/dev/null 2>&1
	ls "$TARGETDIR" >/dev/null 2>&1
	# If not accessible
	while [ "$?" -ne 0 ] || ! mountpoint -q -- "$TARGETDIR";
	do
		printf "\n"
		printf "***[upload]*** NFS not available. Waiting... (%s)" "$SYNCNFS_RETRY_TIMEOUT secs" | grep --color '.'
		
		# Change to other setting if available
		if [ "$TARGETDIR" = "$DIR1"  ]; then
			if [ "$DIR2" != "" ] && [ "$DIR2" != "$DIR1" ]; then
				TARGETDIR="$DIR2"
				TARGETSUBDIR="$SUBDIR2"
			else
				sleep $SYNCNFS_RETRY_TIMEOUT			
			fi
		else
			TARGETDIR="$DIR1"
			TARGETSUBDIR="$SUBDIR1"
			sleep $SYNCNFS_RETRY_TIMEOUT
		fi
		
		printf "\n***[upload]*** NFS Remounting..." | grep --color '.'
		mount "$TARGETDIR" >/dev/null 2>&1
		ls "$TARGETDIR" >/dev/null 2>&1
	done

	mkdir "$TARGETDIR$TARGETSUBDIR" >/dev/null 2>&1

	printf "\n"
	printf "***[upload]*** Started copying \"%s\"..." "$FNAME" | grep --color '.'
	printf "***[upload]*** Destination \"%s\"..." "$TARGETDIR$TARGETSUBDIR" | grep --color '.'

	# copy, then if succeed delete the source file.
	rsync -ab --suffix=".old-$RANDOM" "$FNAME" "$TARGETDIR$TARGETSUBDIR"

	if [ "$?" -eq 0 ]; then
		printf "\n***[upload]*** Copying done. Removing sources on disk.\n" | grep --color '.'
		rm -R "$FNAME"
		exit 0
		break
	fi
	
	printf "\n***[upload]*** Error in copying. Waiting to retry... (%s)\n" "$SYNCNFS_RETRY_TIMEOUT secs" | grep --color '.'
	
	sleep $SYNCNFS_RETRY_TIMEOUT
done
