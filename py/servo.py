import serial

class ServoCtrl:
	def __init__(self, serial_port, baud=38400):
		self.serial = serial.Serial(serial_port, baud, timeout=.005)
		self.servo_ct = 0
		self.servo_ps = None
		self.open()

	def open(self):
		self.serial.open()

		# disable echo. it confuses our output data.
		self.send_cmd('e-')

		self.servo_ct = int(self.send_cmd('sc'))
		self.servo_ps = [ int(self.send_cmd('sq',x)) 
			for x in range(0,self.servo_ct) ]

	def close(self):
		self.serial.close()

	def set_position(self, servo_num, servo_pos):
		self.send_cmd('ss',servo_num,servo_pos)
		x = int(self.send_cmd('sg',bytes(servo_num)))
		print('Got: \"{}\"'.format(x));

	def send_cmd(self, command, *args):
		"""
		Sends a raw command (a string) and args (arbitrary types)
		Returns the answering byte string (if any)
		"""
		# make sure nothing is sitting on input.
		self.serial.flushInput()

		# build our command
		cmd = bytes(command,'ascii')
		cmd += b' ' + b' '.join(bytes(str(arg),'ascii') for arg in args)

		# send it
		self.serial.write(cmd + b'\n')

		# get returned data
		#ret = b''
		#while 1:
		#	ret += self.serial.read(1)
		#	if ret != None:
		#		if ret[-1:] == b'\n':
		#			break

		# FIXME: presently relying on timeout to function.
		ret = self.serial.read(100)

		return ret

