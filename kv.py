from __future__ import print_function, unicode_literals

from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler


class KeyValReqHandler(BaseHTTPRequestHandler):

	def get_none(this):
		this.send_error(404)

	def get_root(this):
		this.send_response(200)
		this.end_headers()

		ua = this.headers.get('User-Agent')

		this.wfile.write(ua)


	def do_POST(this):
		print('got POST')

	def do_GET(this):
		print('got GET {0}'.format(this.path))
		print(this.headers)

		get_resp = {
			'/': this.get_root,
			'' : this.get_none
		}
		try:
			get_resp[this.path]()
		except KeyError:
			get_resp['']()







httpd = HTTPServer(('', 8000), KeyValReqHandler)
httpd.serve_forever()

