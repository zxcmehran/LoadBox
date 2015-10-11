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
import sys
import configuration as c
import socket
try:
	gid = sys.argv[1]
except IndexError:
	print 'Please specify a GID.'
	sys.exit(1)


try:
	s = xmlrpclib.ServerProxy(c.conf_protocol()+c.conf_auth_userpass()+c.conf_address()+':'+c.conf_port()+'/rpc')

	if c.conf_auth_token() != '' :
		files = s.aria2.tellStatus(c.conf_auth_token(), sys.argv[1])
	else:
		files = s.aria2.tellStatus(sys.argv[1])

	print(files['dir']+'/'+files['bittorrent']['info']['name'])
	sys.exit(0)

except xmlrpclib.Fault, e:
	print 'Server responded with an error: %s' % e
	sys.exit(2)
except KeyError, e:
	print 'It seems that it\'s not a torrent.'
	sys.exit(4)
except socket.error, e:
	print 'Socket Error: %s' % e
	sys.exit(5)
except Exception, e:
	print 'Unknown Error: %s' % e
	sys.exit(6)
