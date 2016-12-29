#!/usr/bin/python

'''
LoadBox Downloader Toolset for Unix-Based Systems
For more info:
	http://github.com/zxcmehran/LoadBox

Developed by Mehran Ahadi
http://mehran.ahadi.me/

Licensed undet MIT (Expat) License
'''

import xmlrpclib
import configuration as c

try:
	s = xmlrpclib.ServerProxy(c.conf_protocol()+c.conf_auth_userpass()+c.conf_address()+':'+c.conf_port()+'/rpc')
	
	if c.conf_auth_token() != '' :
		s.aria2.changeGlobalOption(c.conf_auth_token(), {'max-overall-download-limit': c.conf_cron_unlimited_maxspeed(), 'max-overall-upload-limit': c.conf_cron_unlimited_maxupspeed() })
	else:
		s.aria2.changeGlobalOption({'max-overall-download-limit': c.conf_cron_unlimited_maxspeed(), 'max-overall-upload-limit': c.conf_cron_unlimited_maxupspeed() })

except xmlrpclib.Fault, e:
	print 'Server responded with an error: %s' % e
	sys.exit(2)
