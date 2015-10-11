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

if len(sys.argv) < 3 :
	filenum = 0
else:
	filenum = int(sys.argv[2])


try:
	gid = sys.argv[1]
except IndexError:
	print 'Please specify a GID.'
	sys.exit(1)


try:
	s = xmlrpclib.ServerProxy(c.conf_protocol()+c.conf_auth_userpass()+c.conf_address()+':'+c.conf_port()+'/rpc')

	if c.conf_auth_token() != '' :
		files = s.aria2.getFiles(c.conf_auth_token(), gid)
	else:
		files = s.aria2.getFiles(gid)

	print files[filenum]['path']
	sys.exit(0)

except xmlrpclib.Fault, e:
	print 'Server responded with an error: %s' % e
	sys.exit(2)

except IndexError, e:
	print 'File number out of range: %s' % filenum
	sys.exit(3)
except socket.error, e:
	print 'Socket Error: %s' % e
	sys.exit(5)
except Exception, e:
	print 'Unknown Error: %s' % e
	sys.exit(6)
