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
# 
# Version: 1.1
# 
###

{
	# Remember to change it in configuration.conf too
	SAVEFILE="progress.txt"
	
	VERSION="1.1"
	
	if [ "$1" != "now" ]; then
		printf "Waiting for system to bootup. Starting Loadbox in 10 seconds.\n"
		printf "If you are debugging, you can use \"./startup.sh now\" to start immediately.\n"
		sleep 10	
	fi

	printf "\n\n\n"
	printf "###############################" | grep --color '.'
	printf "# LoadBox - Downloader Toolset for Unix-Based Systems" | grep --color '.'
	printf "# Developed by Mehran Ahadi" | grep --color '.'
	printf "# Version $VERSION" | grep --color '.'
	printf "# " | grep --color '.'
	printf "# 	http://github.com/zxcmehran/LoadBox" | grep --color '.'
	printf "# 	http://mehran.ahadi.me/" | grep --color '.'
	printf "###############################" | grep --color '.'
	printf "\n\n\n"

	cd $(dirname "$0")

	if ! [ -e "$SAVEFILE" ]; then
		printf "Generating new savefile\n"
		touch "$SAVEFILE"
	fi
	
	if ! [ -e "configuration.sh" ]; then
		printf "Copying new configuration.sh\n"
		cp sample-configuration.sh configuration.sh
	fi
	
	if ! [ -e "configuration.conf" ]; then
		printf "Copying new configuration.conf\n"
		cp sample-configuration.conf configuration.conf
	fi
	
	if ! [ -e "scripts/configuration.py" ]; then
		printf "Copying new scripts/configuration.py\n"
		cp scripts/sample-configuration.py scripts/configuration.py
	fi

	. $(dirname "$0")/configuration.sh
	
	# If Hotplug enabled
	if [ "$DOWNLOAD_HOTPLUG" != "" ]; then
		. sh/check-hotplug.sh
		
	# If directly downloading to a NAS
	elif [ "$DOWNLOAD_DIR_NFS" != "" ]; then
		. sh/check-nas.sh
		
	# No NAS, no Hotplug
	else
		sh/start-aria2c.sh
	fi

	sh/start-pyserver.sh
} &
