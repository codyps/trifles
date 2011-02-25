#! /usr/bin/env python

act2_spice = """\
* Lab 1, Act 2, BJT {bjt}, Part {part}

Vs  Vi1 0    {wave}
Vcc Vi2 0    DC 5
RC1 Vi2 Vo1  {rc}
RB1 Vi1 Vb   {rb}
Q1  Vo1 Vb 0 {bjt}

{extra}

* Model for 2N3904 NPN BJT (from Eval library in Pspice)
.model Q2N3904 NPN(Is=6.734f Xti=3 Eg=1.11 Vaf=74.03 Bf=416.4 Ne=1.259
+ Ise=6.734f Ikf=66.78m Xtb=1.5 Br=.7371 Nc=2 Isc=0 Ikr=0 Rc=1
+ Cjc=3.638p Mjc=.3085 Vjc=.75 Fc=.5 Cje=4.493p Mje=.2593 Vje=.75
+ Tr=239.5n Tf=301.2p Itf=.4 Vtf=4 Xtf=2 Rb=10)


.control
{action} 
hardcopy {fname}.eps {plot}
.endc
.end
"""

def set_freq(defs):
	freq = defs['freq']
	period = 1.0 / freq
	defs['period'] = period
	defs['pw'] = period / 2

def a2():
    defs = {
            'qn': 0,
    }

    models = [ {'bjt': 'TIM31'}, 
               {'bjt': '2n3904'} ]

    parts = [ {
            'part': 1,
            'action': 'dc Vs 0 5 0.2',
            'extra': '',
            'plot': 'V(Vo1) V(Vi1)',
            'rc': 470,
            'rb': 2000,
            'wave': 'DC 0'
        }, {
            'part':2,
            'action': 'tran {ts} {all_time}',
            'extra': '',
            'plot': 'V(Vo1) V(Vi1)',
            'wave': 'PULSE( {Vil}, {Vih}, 0, {ts}, {ts}, {pw}, {period} )',
            'ts': '2NS',
            'freq': 10e3,
            '_over' : [ 
                { 'rc': 1e3, 'rb': 10e3, 'Vil':0, 'Vih':5 },
                { 'rc': .1e3,'rb': 1e3,  'Vil':0, 'Vih':5 },
                { 'rc': .1e3,'rb': 1e3,  'Vil':-5, 'Vih':5}
                   ]
        }, {
            'part':3,
            'rb':2000,
            'rc':470,
            'extra': """\
* attach shotkey diode between B and C
D1 Vb Vo1 SR102
""",
            '_over': [
                # p1
                {   'freq': 10e3,
                    'wave': 'PULSE( 0, 5, 0, {ts}, {ts}, {pw}, {period} )',
                    'ts':'2NS',
                    'action': 'tran {ts} {all_time}',
                    'plot': 'V(Vo1) V(Vi1)',
                }, { # p2
                    'freq': 10e3,
                    'wave': 'PULSE( -5, 5, 0, {ts}, {ts}, {pw}, {period} )',
                    'ts':'2NS',
                    'action': 'tran {ts} {all_time}',
                    'plot': 'V(Vo1) V(Vi1)'
                }, { # p3
                    # OH god, i need current measurments.
                    'wave': 'DC 5',
                    'plot': 'I(Vs)',
                    'action': 'tran 2NS 4NS'
                }
             ]
        }, {
            'part': 4,
            'rb': 2000,
            'rc': 470,
            'extra': """\
* attach a cap across Vi1 and Vb
C1 Vi1 Vb 1000pF
""",
            'wave': 'PULSE( -5 , 5, 0, {ts}, {ts}, {pw}, {period} )',
            'action': 'tran {ts} {all_time}',
            'plot': 'V(Vo1) V(Vi1)',
            'ts': '2NS',
            'freq': 10e3
    } ]

    for model in models:
        m_defs = dict(defs.items() + model.items())
        for part in parts:
            p_defs = dict(m_defs.items() + part.items())
            defs['qn'] = p_defs['qn'] = m_defs['qn'] = proc(p_defs)

def proc(defs):
    if '_over' in defs:
        cdefs = dict(defs.items())
        del cdefs['_over']
        
        qn = defs['qn']
        for inner in defs['_over']:
            n_defs = dict(cdefs.items() + inner.items())
            qn = cdefs['qn'] = proc(n_defs)
        return qn
    else:
        defs['qn'] = defs['qn'] + 1
        fname = 'a2_{qn:02}_{bjt}_{part}'.format(**defs)
        defs['fname'] = fname

        try:
            set_freq(defs)
            defs['all_time'] = defs['period'] * 2
        except:
            pass

        defs['action'] = defs['action'].format(**defs)
        defs['wave']   = defs['wave'].format(**defs)
        f = open(fname + '.spice.gen', 'w')

        f.write(act2_spice.format(**defs))

        return defs['qn']


if __name__ == "__main__":
	a2()


	


