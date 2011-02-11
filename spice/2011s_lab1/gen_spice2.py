#! /usr/bin/env python

from sys import stdout as out

act1_spice = """\
* Lab 1, Act 1, Diode {diode}, Voltages {Vil}-{Vih}
Vs 0   Vo1 PULSE({Vil}, {Vih}, 0, 0, 0, {pw}, {period})
R1 Vo1 Vo2 1K
D1 Vo2 0   DM1

.model DM1 {diode}

{extra}

.control
tran 
hardcopy {fname}.eps v(Vo1) v(Vo2)
.endc
.end
"""

def set_freq(defs):
	freq = defs['freq']
	period = 1.0 / freq
	defs['period'] = period
	defs['pw'] = period / 2

def a1():

	defs = {
		'qn': 0,
		'extra': ''
	}

	models = [
		{
			'diode': 'D',
			'freq' : 100e3
		}, {
			'diode': '1N4001',
			'freq' : 100e3
		}, {
			'diode': '6A05',
			'extra': """\
*SRC=6A05;DI_6A05;Diodes;Si;  50.0V  6.00A  2.00us   Diodes Inc.
.MODEL 6A05 D  ( IS=52.4n RS=7.00m BV=50.0 IBV=10.0u
+ CJO=60.0p  M=0.333 N=1.70 TT=2.88u )""",
			'freq' : 10e3
		}
	]

	vs = [ (0, 10), (-10, 10), (-10, 0) ]

	for model in models:
		m_defs = dict(defs.items() + model.items())

		set_freq(m_defs)
		
		for vil, vih in vs:
			m_defs['Vil'] = vil
			m_defs['Vih'] = vih
			m_defs['qn'] = m_defs['qn'] + 1

			fname = 'a1_{qn}_{diode}_{Vil}_{Vih}'.format(**m_defs)
			m_defs['fname'] = fname

			f = open(fname + '.spice', 'w')

			f.write(act1_spice.format(**m_defs))

if __name__ == "__main__":
	a1()


	


