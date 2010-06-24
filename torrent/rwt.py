#! /usr/bin/env python
from __future__ import print_function
from sys import argv

for arg in argv[1:]:
    print(arg)

if (len(argv) < 2):
    print("usage: rwt.py torrent")
