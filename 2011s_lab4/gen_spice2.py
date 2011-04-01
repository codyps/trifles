#! /usr/bin/env python

act2_spice = """\
* Lab 2, Act 1, NMOS inverter, Part {part}, Plot Num {qn}

`include "nmos_inv_2.1.spice"

nmos_inv 0 vin_r vout vdd

rin vin vin_r
Vsdd vdd 0 DC 5

{extra}

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

class OverList(list):
    def __init__(self, *args, **kwargs):
        list.__init__(self, *args, **kwargs)
        self.over = []


class OverDict(dict):
    def __init__(self, *args, **kwargs):
        dict.__init__(self, *args, **kwargs)
        self.over = []

def od(*x, **y):
    return OverDict(*x, **y)

def ol(*x, **y):
    return OverList(*x, **y)

def a2():
    defs = {'qn': 0}
   
    parts = [ {
            'part': 1,
            'action': 'dc Vsin 0 5 0.01',
            'extra': 'Vsin vin 0 DC 0',
            'plot': 'V(vout) V(vin)',
        }, {
            'part': 2,
            'action': 'tran {ts} {all_time}',
            'freq': 10e3
            'extra': 'Vsin vin 0 DC 0 PULSE(0 4 0 {step} {step} {pw} {period})',
            'plot': 'V(Vo1) V(Vi1)',
        }, {
            'part':3,
            'action': 'tran {ts} {all_time}',
            'freq': 10e3
            'extra': """\
Vsin vin 0 DC 0 PULSE(0 4 0 {step} {step} {pw} {period})
C vout 0 1000p
""",
            'plot': 'V(Vo1) V(Vi1)',
        } ]

    defs.over = models

    proc(defs)

def proc(defs):
    if hasattr(defs, 'over'):
        cdefs = dict(defs.items())
        del cdefs.over
        
        qn = defs['qn']
        for inner in defs.over:
            n_defs = dict(cdefs.items() + inner.items())
            qn = cdefs['qn'] = proc(n_defs)
        return qn
    else:
        try:
            set_freq(defs)
            defs['all_time'] = defs['period'] * 2
        except:
            pass

        for k,v in defs.pairs():
            try:
                defs[k] = v.format(**defs)
            except:
                pass

        defs['qn'] = defs['qn'] + 1
        fname = '{bjt}_{part}_{qn:02}'.format(**defs)
        defs['fname'] = fname

        f = open(fname + '.spice.gen', 'w')

        f.write(act2_spice.format(**defs))

        return defs['qn']

if __name__ == "__main__":
	a2()


	


