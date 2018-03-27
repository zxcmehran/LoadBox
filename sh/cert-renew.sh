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

# For the first time, fill related configuration fields on configuration.sh file then run it directly and follow the interactive procedure.
# Then set a cronjob to run it every 1st of each month to renew the certificate automatically.

. "$(dirname "$0")"/../configuration.sh
cd "$(dirname "$0")"/..

if [ -z "$CERT_RENEW_HOSTNAME" ]; then
	exit 0
fi

PIDNUM="0"

WEBROOT="$CERT_RENEW_WEBROOT"

# Start standalone webserver if needed
if [ "$CERT_RENEW_START_80_WEBSERVER" -eq "1" ]; then
	mkdir renewtmp
	cd renewtmp
	python -m SimpleHTTPServer 80 &
	PIDNUM=$!
	cd ..

	WEBROOT="./renewtmp"

fi


if hash certbot 2>/dev/null; then
	CERTCOM="certbot"
else
	if ! [ -e "certbot-auto" ]; then
	    wget https://dl.eff.org/certbot-auto
		chmod a+x certbot-auto
	fi
	CERTCOM="./certbot-auto"

	$CERTCOM --install-only
fi

echo "Trying to renew..."

RETDATA=$($CERTCOM renew 2>&1)

echo $RETDATA | grep "Cert not yet due for renewal" >/dev/null 2>&1

if [ "$?" -ne "0" ]; then
	echo $RETDATA | grep "No renewals were attempted." >/dev/null 2>&1

	if [ "$?" -eq "0" ]; then
		echo "Generating new certificates for $CERT_RENEW_HOSTNAME ..."
		$CERTCOM certonly --webroot -w $WEBROOT -d $CERT_RENEW_HOSTNAME
	fi
fi


# Copy new ones
echo "Installing new certificate on LoadBox..."
cp "/etc/letsencrypt/live/$CERT_RENEW_HOSTNAME/fullchain.pem" ./cert.pem
cp "/etc/letsencrypt/live/$CERT_RENEW_HOSTNAME/privkey.pem" ./cert.key


# Cleanup
if [ "$CERT_RENEW_START_80_WEBSERVER" -eq "1" ]; then
	echo "Closing standalone webserver..."
	kill -9 $PIDNUM >/dev/null 2>&1
	rm -rf renewtmp
fi

# Restart
echo "Restarting web and aria2c instances..."
if [ -e "pid-pyserver" ]; then
	PID_PY="$(<pid-pyserver)"
	if [ "SecureHTTPServe" == "$(ps -p $PID_PY -o comm=)" ]; then
		kill -9 $PID_PY >/dev/null 2>&1
		. sh/start-pyserver.sh
	fi
fi

if [ -e "pid-aria2c" ]; then
	PID_AR="$(<pid-aria2c)"

	if [ "aria2c" == "$(ps -p $PID_AR -o comm=)" ]; then
		kill -9 $PID_AR >/dev/null 2>&1
		. sh/start-aria2c.sh
	fi
fi

#Report

echo "Done."

if [ "$IFTTT_MAKER_KEY" != "" ]; then
	curl -X POST -H "Content-Type: application/json" -d "{\"value1\":\"Generated new certificates for LoadBox.\"}" https://maker.ifttt.com/trigger/$IFTTT_MAKER_EVENT/with/key/$IFTTT_MAKER_KEY >/dev/null 2>&1
fi

