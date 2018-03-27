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
	. "$(dirname "$0")"/../configuration.sh

	cd "$(dirname "$0")"/..

	echo "Starting Web Server." | grep --color '.'
	sudo -u $HTTP_WORKING_USER pyserver/SecureHTTPServer.py webui "$WEBPORT" "$WEBUSER:$WEBPASS" "$(readlink -e "$CERTFILE")" "$(readlink -e "$KEYFILE")" &

	sleep 1

	SUBPID="$(ps --ppid $! -o pid= | sed 's/^[ \t]*//;s/[ \t]*$//')"

	echo "$SUBPID" > ./pid-pyserver

	#echo "Error: Web Server stopped!" | grep --color '.'
} &
