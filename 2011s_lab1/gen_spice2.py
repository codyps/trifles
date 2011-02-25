#! /usr/bin/env python

act1_spice = """\
* Lab 1, Act 1, Diode {diode}, Voltages {Vil} to {Vih}
Vs Vo1 0   DC {Vil} PULSE({Vil}, {Vih}, 0, {ts}, {ts}, {pw}, {period})
R1 Vo1 Vo2 1K
D1 Vo2 0 {diode}

.MODEL  DN914  D  (IS=4.77E-10 N=1.59 BV=133.3 IBV=1.0E-07 
+ RS=6.01E-01 CJO=4.0E-12 VJ=.75 M=.333 TT=5.76E-09)

.MODEL  DN4001  D  (IS=5.86E-06 N=1.7 BV=6.66E+1 IBV=5.0E-07
+ RS=3.62E-02 CJO=5.21E-11 VJ=.34 M=.38 TT=5.04E-06)

*SRC=6A05;DI_6A05;Diodes;Si;  50.0V  6.00A  2.00us   Diodes Inc.
.MODEL D6A05 D  ( IS=52.4n RS=7.00m BV=50.0 IBV=10.0u
+ CJO=60.0p  M=0.333 N=1.70 TT=2.88u )

.control
tran {ts} {tl}
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
		'extra': '',
		'ts': 0.001
	}

	models = [
		{
			'diode': 'dn914',
			'freq' : 100e3,
		}, {
			'diode': 'dn4001',
			'freq' : 100e3,
		}, {
			'diode': 'd6a05',
			'freq' : 10e3,
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
			m_defs['tl'] = m_defs['period'] * 2

			f = open(fname + '.spice.gen', 'w')

			f.write(act1_spice.format(**m_defs))

		defs['qn'] = m_defs['qn']

if __name__ == "__main__":
	a1()


	


