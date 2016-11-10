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
		files = s.aria2.tellStatus(c.conf_auth_token(), gid)
	else:
		files = s.aria2.tellStatus(gid)

	if 'followedBy' in files:
		print 'It\'s a metalink or torrent descriptor file. Skipping.';
		sys.exit(7);

	relpath = files['files'][0]['path'][len(files['dir'])+1:]

	if(relpath.find('/') == -1):
		# If it's a single file situation
		print files['dir']+'/'+relpath
	else:
		# If it's a multiple file situation
		pardir = relpath[0:relpath.index('/')]
		print(files['dir']+'/'+pardir)

	sys.exit(0)

except xmlrpclib.Fault, e:
	print 'Server responded with an error: %s' % e
	sys.exit(2)
except KeyError, e:
	print 'Invalid response.'
	sys.exit(4)
except socket.error, e:
	print 'Socket Error: %s' % e
	sys.exit(5)
except Exception, e:
	print 'Unknown Error: %s' % e
	sys.exit(6)
