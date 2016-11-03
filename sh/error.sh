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

if [ "$IFTTT_MAKER_KEY" != "" ]; then

	# Get downloaded file(s) address on disk
	FNAME="$(./scripts/getfile.py "$1")"
	ERR="$?"
	if [ "$ERR" -ne 0 ]; then
		printf "\n%s" "$FNAME"
		printf "\nInvalid response. Error code %s\n" "$ERR"
		exit
	fi

	DLERR="$(./scripts/geterror.py "$1")"
	FBASENAME="$(basename $FNAME)"
	curl -X POST -H "Content-Type: application/json" -d "{\"value1\":\"Downloading $FBASENAME failed. Error: $DLERR\"}" https://maker.ifttt.com/trigger/$IFTTT_MAKER_EVENT/with/key/$IFTTT_MAKER_KEY
fi
