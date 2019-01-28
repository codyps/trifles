#! /usr/bin/env python
from __future__ import print_function,unicode_literals
import sys
import math

import itertools
import attr
from sumtype import sumtype, match

def format_bits(val, bit_map):
    s = []
    cval = val
    for (f, l, name) in bit_map:
        if l <= f:
            raise Exception("first bit must be less than last")
        ct = l - f
        mask = (1 << ct) - 1
        mask = mask << f
        fv = (val & mask) >> f
        if ct == 1:
            if fv:
                s.append(name)
        else:
            s.append("{}[0x{:X}]".format(name, fv))
        cval &= ~mask

    if cval:
        ccval = cval
        sv = []
        while ccval:
            fs = int(math.log(ccval, 2))
            sv.append("1<<{}".format(fs))
            ccval &= ~(1<<fs)
        s.append("0x{:08X}[{}]".format(cval, '|'.join(sv)))

    if len(s):
        return '|'.join(s)
    else:
        return '0'


def _main(argv):
    stm32f7x_flash_cr_bits = [
        (0,1,"PG"),
        (1,2,"SER"),
        (2,3,"MER/MER1"),
        (3,8,"SNB"),
        (8,10,"PSIZE"),
        (15,16,"MER2"),
        (16,17,"STRT"),
        (24,25,"EOPIE"),
        (25,26,"ERRIE"),
        (31,32,"LOCK"),
    ]

    armv7m_dhcsr_bits = [
        (0,1,"C_DEBUGEN"),
        (1,2,"C_HALT"),
        (2,3,"C_STEP"),
        (5,6,"C_SNAPSTALL"),
        (16,17,"S_REGRDY"),
        (17,18,"S_HALT"),
        (18,19,"S_SLEEP"),
        (19,20,"S_LOCKUP"),
        (24,25,"S_RETIRE_ST"),
        (25,26,"S_RESET_ST"),
    ]

    armv7m_mmfsr_bits = [
        (0,"IACCVIOL"),
        (1,"DACCVIOL"),
        (3,"MUNSTKERR"),
        (4,"MSTKERR"),
        (5,"MLSPERR"),
        (7,"MMARVALID"),
    ]

    armv7m_bfsr_bits = [
        (0,"IBUSERR"),
        (1,"PRECISERR"),
        (2,"IMPRECISERR"),
        (3,"UNSTKERR"),
        (4,"STKERR"),
        (5,"LSPERR"),
        (7,"BFARVALID"),
    ]

    armv7m_ufsr_bits = [
        (0, "UNDEFINSTR"),
        (1, "INVSTATE"),
        (2, "INVPC"),
        (3, "NOCP"),
        (8, "UNALIGNED"),
        (9, "DIVBYZERO"),
    ]

    armv7m_hfsr_bits = [
        (1,2,"VECTTBL"),
        (30,31,"FORCED"),
        (31,32,"DEBUGEVT"),
    ]

    armv7m_dfsr_bits = [
        (0,1,"HALTED"),
        (1,2,"BKPT"),
        (2,3,"DWTTRAP"),
        (3,4,"VCATCH"),
        (4,5,"EXTERNAL"),
    ]

    armv7m_xpsr_bits = [
        (0,9,"EX_NUM"),
        (10,16,"ICI/IT"),
        (16,20,"GE"),
        (24,25,"T"),
        (25,27,"ICI/IT2"),
        (27,28,"Q"),
        (28,29,"V"),
        (29,30,"C"),
        (30,31,"Z"),
        (31,32,"N"),
    ]

    armv7m_cfsr_bits = []
    armv7m_cfsr_bits += [(i, i+1, name) for (i, name) in armv7m_mmfsr_bits]
    armv7m_cfsr_bits += [(i+8, i+9, name) for (i, name) in armv7m_bfsr_bits]
    armv7m_cfsr_bits += [(i+16, i+17, name) for (i, name) in armv7m_ufsr_bits]

    #for (s,e,n) in armv7m_cfsr_bits:
    #    print(s, e, n)

    regs = {
        "DFSR": armv7m_dfsr_bits,
        "HFSR": armv7m_hfsr_bits,
        "DHCSR": armv7m_dhcsr_bits,
        "xPSR": armv7m_xpsr_bits,
        "UFSR": armv7m_ufsr_bits,
        "CFSR": armv7m_cfsr_bits,
        "raw": [],
    }

    for (name, val_str) in zip(argv[1::2], argv[2::2]):
        v = int(val_str, 0)
        reg = regs[name]
        bits = format_bits(v, reg)
        print('{}=0x{:08X}={}'.format(name, v, bits))

    #v=int(argv[1], 0)
    #print('FLASH_CR={}'.format(format_bits(int(argv[1], 0), stm32f7x_flash_cr_bits)))
    #print('DHCSR={}'.format(format_bits(int(argv[1], 0), armv7m_dhcsr_bits)))
    #print('CFSR=0x{:08X}={}'.format(int(argv[1], 0), format_bits(int(argv[1], 0), armv7m_cfsr_bits)))
    #print('HFSR=0x{:08X}={}'.format(int(argv[1], 0), format_bits(int(argv[1], 0), armv7m_hfsr_bits)))

if __name__ == "__main__":
    _main(sys.argv)
