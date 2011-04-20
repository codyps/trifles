#! /usr/bin/env python
from __future__ import print_function

goal = [(1, 1),(2, 8),(3, 32),(4, 64),(5, 128),(6, 256),(7, 1024)]

def match(x):
    return 2**(x - 1)

def compare(fn):
    for u in goal:
        i, o = u
        mo = fn(i)

        print('{0} => {1} : {2}'.format(i, o , mo))
