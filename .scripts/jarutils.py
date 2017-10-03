#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import sys, os, os.path, fnmatch, struct, re
from zipfile import BadZipfile, ZipFile
from collections import defaultdict
import json

def rglob(directory, pattern):
	for root, dirnames, filenames in os.walk(directory):
		for filename in fnmatch.filter(filenames, pattern):
			yield os.path.join(root, filename)

known_versions = {(i, 0): 'java 1.'+str(i-44) for i in range(46,54)}
known_versions[(45, 3)]='java 1.0'

def list_classes(jarfile):
  """ gets the list of all the class files in a jar"""
  with ZipFile(jarfile,'r') as z:
    for n in z.namelist():
      if n.endswith('.class'):
        try:
          yield get_fmt(z.open(n)), n
        except Exception,e:
          pass

def get_fmt(fp):
     """ reads the header of a class file to determine the target java version (fp is a file-like stream"""
     cafebabe, minor, major = struct.unpack('>IHH', fp.read(8))
     if cafebabe == 0xcafebabe:
         return known_versions[major, minor]
     else:
         raise Exception('invalid magic bytes (expected 0xcafebabe, got '+hex(cafebabe) )

def get_classfileformat(jarfile):
        """gets statistics about the target versions of the class files contained in the jar"""
	formats = defaultdict(lambda :0)
	try:
		with ZipFile(jarfile,'r') as z:
			for n in z.namelist():
				if n.endswith('.class'):
					formats[get_fmt(z.open(n))] +=1
		return repr(dict(formats))
	except Exception, e:
		return json.dumps({'error':repr(e)})

def print_classesformats(directory):
    for classfile in rglob(directory, pattern="*.class"):
         with file(classfile, 'rb') as fp:
             try:
                 print repr({get_fmt(fp):1}), ':',classfile
             except Exception, e:
                 raise
                 print '','[ERROR reading '+classfile+']'

def usage():
	print 'usage : '+sys.argv[0]+' <directory with jars> --classversions [-v]?| <directory with jars> --find <search pattern>'
	sys.exit(-2)
if __name__ == '__main__':
	if len(sys.argv) <3:
		usage()
	
	if '--classversions' in sys.argv:
	    jars = list(rglob(sys.argv[1], pattern='*.jar'))
	    wars = list(rglob(sys.argv[1], pattern='*.war'))
	    for jarfile in jars + wars:
		print get_classfileformat(jarfile), ':', jarfile
		if '-v' in sys.argv:
		    for ver, filename in list_classes(jarfile):
		        print "\t", ver, '=>', filename
		    print '-'*80
	    print_classesformats(sys.argv[-2])
		
	elif sys.argv[2] == '--find':
		found = False
		for jarfile in rglob(sys.argv[1],pattern='*.jar'):
			try :
				with ZipFile(jarfile,'r') as z:
					for n in z.namelist():
						if re.match(sys.argv[-1], n):
							found = True
							print jarfile ,":", n
							break
			except BadZipfile, e:
				pass#print >>sys.stderr,'[WARNING]', e, jarfile
		if not found:
			sys.exit(-1)
	else:
		usage()

