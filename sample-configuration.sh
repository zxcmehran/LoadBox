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

# User to use for aria2c
# Use root if network storages you use are not mountable by user although it's NOT RECOMMENDED.
ARIA2C_WORKING_USER="pi"

# User to use for webserver
# Use it if you want to use a port < 1024 although it's NOT RECOMMENDED.
HTTP_WORKING_USER="pi"

# Listening port for web interface
# It's recommended to use a number greater than 1023.
WEBPORT="8000"

# Interface Authentication. Leave both empty to disable.
WEBUSER=""
WEBPASS=""

# If you want HTTPS enabled, Specify certificate and key file.
CERTFILE=""
KEYFILE=""
# Use below values if you're going to use auto renewal
#CERTFILE="cert.pem"
#KEYFILE="cert.key"

# Download Directory
# If you are using hotplug functionality, it should be on hotplug mount directory.
# If it's on a network storage, consider filling DOWNLOAD_DIR_NFS var.
DOWNLOAD_DIR="~/Downloads"

# Set to nfs mount point if you are downloading DIRECTLY to a network storage. It will help to keep it mounted.
DOWNLOAD_DIR_NFS=""

# If you want to use flash hotplug, specify mount directory.
DOWNLOAD_HOTPLUG=""

# If network sync enabled, file will be moved to network storage after download completion to free up disk space.
NETWORK_SYNC="0"

# Mount point of network storage
NETWORK_DIR1=""
# Directory on network storage to place files inside (WITH BEGINNING SLASH)
NETWORK_SUBDIR1=""

# Fallback for first directory
NETWORK_DIR2=""
NETWORK_SUBDIR2=""

# Timeout to retry syncing files over network if task failed
SYNCNFS_RETRY_TIMEOUT=60

# Timeout to retry connecting NFS storage used as direct download location
DIRECTNFS_RETRY_TIMEOUT=5

# Time interval to check if NFS for direct download location is alive
DIRECTNFS_CHECK_INTERVAL=10

# Time interval to check if Hotplug flash storage location is mounted and accessible
HOTPLUG_CHECK_INTERVAL=10

# IFTTT Maker key for push notifications.
IFTTT_MAKER_KEY=""

# IFTTT Maker Event name. Useful if you're running multiple LoadBox instances with a single IFTTT account.
IFTTT_MAKER_EVENT="loadbox_notification"

# Should start a standalone webserver on port 80 for certificate renewal? (In case you DON'T HAVE a webserver running on 80 currently.)
CERT_RENEW_START_80_WEBSERVER="1"

# Used to issue certificate. Also used to get certificate from path /etc/letsencrypt/live/[MY.HOST.EXAMPLE.COM]/fullchain.pem
# Example: myhost.mydomain.com
CERT_RENEW_HOSTNAME=""

# In case you HAVE a webserver running on port 80 currently, specify it's webroot path.
# Example: /var/www/myhost
CERT_RENEW_WEBROOT=""
