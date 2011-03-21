#! /usr/bin/env python
from __future__ import print_function
import code
import sys

class X():

    def _z(self, y):
        print('in _z')
        print(y)

    def x(self, y):
        print('in x')
        self._z(y)


x = X()

x.x('hey')

code.interact(local=locals())
