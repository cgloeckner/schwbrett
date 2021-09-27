#!/usr/bin/python3

import requests, xml, threading, tempfile, datetime
from requests.auth import HTTPBasicAuth

import xml.etree.ElementTree as ET

import os

from bottle import get, view, run, static_file, redirect


# -----------------------------------------------------------------------------

class Resource(object):
	def __init__(self, raw):
		tmp = raw.split(',')
		self.fname   = tmp[0].split('"')[1]
		self.fsize   = int(tmp[1])
		self.lastmod = int(tmp[2])
		self.data    = None
	
	def next(self):
		return True

	def multiNext(self):
		# start plan from beginning
		if self.page_index == self.num_pages - 1:
			self.page_index = -1
		
		# next page
		self.page_index += 1
		
		# signal end of that plan
		return self.page_index == self.num_pages - 1

class WebLoader(object):
	def __init__(self, rooturl, user, passwd, suburl):
		# asyncronous reloading
		self.lock   = threading.Lock()
		self.loader = None
		
		# plan data
		self.data  = list()
		self.index = 0
		self.error = None
		
		# http stuff
		self.base = '{0}/{1}'.format(rooturl, suburl)
		self.auth = (user, passwd)
		
	def start(self):
		self.loader = threading.Thread(target=self.reload)
		self.loader.start()
		
	def reload(self):
		# fetch filename list from server
		try:
			res = requests.get('{0}/dir.php'.format(self.base), auth=self.auth)
		except requests.exceptions.ConnectionError as error:
			with self.lock:
				self.error = error
			return
		
		self.error = None
		self.new_data = list()
		try:
			for line in res.text.split('\n'):
				if line.startswith('"'):
					self.fetch(Resource(line))
		except requests.exceptions.ConnectionError as e:
			self.new_data = e
		
		with self.lock:
			self.data = self.new_data
		
	def fetch(self, res):
		"""Needs to be overwritten for custom loading."""
		if self.isRecent(res):
			self.new_data.append(res)
			self.refetch(res)
	
	def next(self):
		# try to reload on error
		with self.lock:
			error = self.error
		if error is not None:
			self.reload()
			with self.lock:
				error = self.error
			if self.error is not None:
				raise self.error
			
		elem = self.data[self.index]
		
		if not elem.next():
			return elem
		
		# adjust index
		self.index += 1
		if self.index >= len(self.data):
			self.index = 0
			
			# trigger reload
			if self.loader is None or not self.loader.is_alive():
				self.start()
		
		return elem
	
	def isRecent(self, node):
		return True


class Vertretungsplan(WebLoader):
	"""Loads XML files from external server and caches them for display.
Reloads XML files after each one was displayed."""
	def __init__(self, rooturl, user, passwd):
		super().__init__(rooturl, user, passwd, 'substituteplans')
		self.page_size = 10 # FIXME
		self.start()
	
	def refetch(self, node):
		res = requests.get('{0}/{1}'.format(self.base, node.fname), auth=self.auth)
		node.data = ET.fromstring(res.text)
		
		# count how many pages are necessary
		num_entries     = len(node.data.find('haupt'))
		node.num_pages  = 1 + (num_entries-1) // self.page_size
		node.page_index = 0
		
		if node.num_pages > 1:
			# enable page traverse
			node.page_index = -1
			node.next       = node.multiNext
		
		print('{0} => {1} \t {2}x in {3}'.format(node.fname, res, num_entries, node.num_pages))
	
	def isRecent(self, node):
		date = node.fname.split('.xml')[0].split('Schueler')[1]
		y = int(date[0:4])
		m = int(date[4:6])
		d = int(date[6:8])
		last_date = datetime.datetime(year=y, month=m, day=d+1)
		# d+1: today() contains hour etc.
		return last_date >= datetime.datetime.today()


class Diashow(WebLoader):
	def __init__(self, rooturl, user, passwd):
		super().__init__(rooturl, user, passwd, 'diashow')
		self.cache = tempfile.TemporaryDirectory()
		self.start()
		
	def refetch(self, node):
		load = True
		for index, elem in enumerate(self.data):
			if elem.fname == node.fname and elem.lastmod == node.lastmod:
				# found and not modified
				load = False
				break
		
		if load:
			res = requests.get('{0}/{1}'.format(self.base, node.fname), auth=self.auth)
			local_fname = '{0}/{1}'.format(self.cache.name, node.fname)
			with open(local_fname, 'wb') as h:
				h.write(res.content)
			
			print('{0} loaded'.format(node.fname))
		else:
			print('{0} from cache'.format(node.fname))
	
# -----------------------------------------------------------------------------

def main():
	last_error = None
	
	# load config
	with open('config.txt', 'r') as h:
		rooturl, user, passwd = h.read().split('\n')
	
	v = Vertretungsplan(rooturl, user, passwd)
	d = Diashow(rooturl, user, passwd)
	
	@get('/static/<fname>')
	def static_files(fname):
		return static_file(fname, root='./static')
	
	@get('/error')
	def error():
		global last_error
		print(last_error)
		return '<h1>Verbindung unterbrochen</h1>'
	
	@get('/')
	@view('index')
	def home():
		return dict()
	
	@get('/vertretung')
	@view('vertretung')
	def vertretung():
		return dict()
	
	@get('/vertretung/next/<version>')
	@view('plan')
	def get_plan(version):
		try:
			node = v.next()
		except Exception as error:
			global last_error
			last_error = error
			redirect('/error')
		return dict(node=node, page_size=v.page_size)
	
	@get('/diashow')
	@view('diashow')
	def diashow():
		return dict()
	
	@get('/diashow/next/<version>')
	def get_dia(version):
		try:
			node = d.next()
		except Exception as error:
			global last_error
			last_error = error
			redirect('/error')
		return static_file(node.fname, d.cache.name)
	
	run(debug=True)


if __name__ == '__main__':
	main()

