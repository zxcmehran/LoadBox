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
# Version: 1.0
# 
###

{
	VERSION="1.0"
	
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
	
	. $(dirname "$0")/configuration.sh

	cd $(dirname "$0")

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
