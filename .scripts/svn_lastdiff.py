#!/usr/bin/env python2
import subprocess
import os, sys

from xml.dom.minidom import parseString

cmd = ['svn', 'log', '--xml']
if len(sys.argv) > 1:
   cmd.append(sys.argv[-1])

xml = subprocess.check_output(cmd)
dom = parseString(xml)
entries = dom.getElementsByTagName('logentry')
if len(entries) >= 2:
    lastrev = dom.getElementsByTagName('logentry')[1].getAttribute('revision')
    cmd = ['svn', 'diff', '-r'+lastrev]
    if len(sys.argv) > 1:
       cmd.append(sys.argv[-1])
    print subprocess.check_output(cmd)

