#! /usr/bin/env python3

from optparse import OptionParser
import servo

usage = "usage: %prog [options] <serial_port>"
parser = OptionParser(usage=usage)
options, args = parser.parse_args()

if len(args) != 1:
	parser.error("incorrect number of arguments")

ser_port_n = args[0]

print('Opening serial port {}'.format(ser_port_n))
x = servo.ServoCtrl(ser_port_n)
print(x.servo_ps)
try:
	while 1:
		print(x.send_cmd('u'))
except KeyboardInterrupt:
	pass
