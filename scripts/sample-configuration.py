'''
LoadBox Downloader Toolset for Unix-Based Systems
For more info:
	http://github.com/zxcmehran/LoadBox

Developed by Mehran Ahadi
http://mehran.ahadi.me/

Licensed undet MIT (Expat) License
'''

# Remember, remove auto-generated file "configuration.pyc" after editing this file to make changes take effect.

def conf_address():
	return '0.0.0.0'; # Relative to System itself. Use your certificate's Fully Qualified Domain Name if you are using HTTPS.

def conf_port():
	return '6800';

def conf_auth_token():
	token = ''; # define your token here

	if token != '' :
		return 'token:'+token;
	else :
		return '';

def conf_protocol():
	secure = 0; # Set to 1 to enable HTTPS
	if secure == 1 :
		return "https://"
	else:
		return "http://"

def conf_auth_userpass():
	username = ''; # define your username here
	password = ''; # define your password here

	if username != '' :
		return username+':'+password+'@';
	else :
		return '';


def conf_cron_maxspeed():
	return '32K'; # Max Download Speed. Used by speed limiter script

def conf_cron_maxupspeed():
	return '10K'; # Max Upload Speed. Used by speed limiter script

