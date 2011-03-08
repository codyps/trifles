#! /usr/bin/env python

act2_spice = """\
* Lab 1, Act 2, BJT {bjt}, Part {part}, Plot Num {qn}

Vs  Vi1 0    {wave}
Vcc Vi2 0    DC 5
RC1 Vi2 Vo1  {rc}
RB1 Vi1 Vb   {rb}
Q1  Vo1 Vb 0 {bjt}

{extra}

* Model for 2N3904 NPN BJT (from Eval library in Pspice)
.model 2N3904 NPN(Is=6.734f Xti=3 Eg=1.11 Vaf=74.03 Bf=416.4 Ne=1.259
+ Ise=6.734f Ikf=66.78m Xtb=1.5 Br=.7371 Nc=2 Isc=0 Ikr=0 Rc=1
+ Cjc=3.638p Mjc=.3085 Vjc=.75 Fc=.5 Cje=4.493p Mje=.2593 Vje=.75
+ Tr=239.5n Tf=301.2p Itf=.4 Vtf=4 Xtf=2 Rb=10)

.MODEL tip31 npn
+IS=1e-09 BF=3656.16 NF=1.23899 VAF=10
+IKF=0.0333653 ISE=1e-08 NE=2.29374 BR=0.1
+NR=1.5 VAR=100 IKR=0.333653 ISC=1e-08
+NC=1.75728 RB=6.15083 IRB=100 RBM=0.00113049
+RE=0.0001 RC=0.0491489 XTB=50 XTI=1
+EG=1.05 CJE=3.26475e-10 VJE=0.446174 MJE=0.464221
+TF=2.06218e-09 XTF=15.0842 VTF=25.7317 ITF=0.001
+CJC=3.07593e-10 VJC=0.775484 MJC=0.476498 XCJC=0.750493
+FC=0.796407 CJS=0 VJS=0.75 MJS=0.5
+TR=9.57121e-06 PTF=0 KF=0 AF=1

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

    models = [ {'bjt': 'tip31'}, 
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
            'ts': '10NS',
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
                    'ts':'10NS',
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
            'ts': '10NS',
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
        fname = '{bjt}_{part}_{qn:02}'.format(**defs)
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


	


