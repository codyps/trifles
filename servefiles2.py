#!/usr/bin/env python
# coding: utf-8 -*-

import os
import socket
import struct
import threading
import argparse
import itertools
import shutil
from pathlib import Path

from http.server import BaseHTTPRequestHandler
from socketserver import TCPServer

ACCEPTED_SUFFIX = ('.cia', '.tik', '.cetk', '.3dsx')

def grouper(iterable, n):
    while True:
        yield itertools.chain((next(iterable),), itertools.islice(iterable, n-1))

class SpecificFilesHTTPRequestHandler(BaseHTTPRequestHandler):
    server_version = "FBI-servefiles/0"

    def do_GET(self):
        """Serve a GET request."""
        f = self.send_head()
        if f:
            shutil.copyfileobj(f, self.wfile)

    def do_HEAD(self):
        """Serve a HEAD request."""
        self.send_head()

    def send_head(self):
        ctype = 'application/octet-stream'
        try: 
            file_num = int(self.path[1:])
            f = self.server.files[file_num]
        except Exception as e:
            print("file not found: {}, {}".format(self.path, e))
            self.send_error(404, "File not found")
            return None

        self.send_response(200)
        self.send_header("Content-type", ctype)
        fs = os.fstat(f.fileno())
        self.send_header("Content-Length", str(fs[6]))
        self.send_header("Last-Modified", self.date_time_string(fs.st_mtime))
        self.end_headers()
        return f

class FbiHttpServer(TCPServer):
    # TODO: restrict this to the device we're sending to. ie: fiddle with
    # connection accept to filter out non-dest
    def __init__(self, server_addr, files):
        self.files = files
        super().__init__(server_addr, SpecificFilesHTTPRequestHandler)

def main():
    p = argparse.ArgumentParser(description="Send files to FBI")
    p.add_argument('target_host', help="hostname or ip of the 3ds running FBI")
    p.add_argument('file_or_dir', nargs='+', help="Files or directories of files to send")

    args = p.parse_args()

    # accumulate list of files
    files = []
    for f in args.file_or_dir:
        p = Path(f)
        try:
            for pp in p.iterdir():
                if pp.suffix in ACCEPTED_SUFFIX:
                    files.append(open(pp, 'rb'))
        except:
            if p.suffix in ACCEPTED_SUFFIX:
                # add file
                files.append(open(p, 'rb'))

    print("files:")
    for f in files:
        print(" {}".format(f.name))

    # create serve socket
    server = FbiHttpServer(('', 0), files)
    http_addr = server.socket.getsockname()

    # create command socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((args.target_host, 5000))

    sock_addr = sock.getsockname()

    print('http_addr={}'.format(http_addr))
    print('sock_addr={}'.format(sock_addr))
    url_base = '{}:{}/'.format(sock_addr[0], http_addr[1])

    # run the server
    thread = threading.Thread(target=server.serve_forever)
    thread.start()

    # send urls
    # group into blocks of 128 urls
    for g in grouper(enumerate(files), 128):
        data = '\n'.join([url_base + str(num) for num, name in g]) + '\n'
        data = struct.pack('!L', len(data)) + data.encode('ascii')
        sock.sendall(data)

    # XXX: determine if we need to do this for _each_ transfer or if we can do it once on exit
    b = sock.recv(1)
    print("got {}".format(b))
    sock.close()

    server.shutdown()

if __name__ == "__main__":
    main()


# payload:
#   up to 128 of:
#   '<addr>:<port>/<path>\n'
# max url length is 1024 bytes
