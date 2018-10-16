#! /usr/bin/env python
from __future__ import print_function,unicode_literals
import sys
import math

import itertools
#import attr
#from sumtype import sumtype, match


def format_bits(val, bit_map):
    s = []
    cval = val
    for bit_spec in bit_map:
        try:
            (f, l, name) = bit_spec
        except ValueError:
            (f, name) = bit_spec
            l = f + 1
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

eth_phy_bmcr_bits = [
    (15, "RESET"),
    (14, "LOOPBACK"),
    (13, "SPEED_SELECTION"),
    (12, "AUTO_NEG_ENABLE"),
    (11, "POWER_DOWN"),
    (10, "ISOLATE"),
    (9, "RESTART_AUTO_NEG"),
    (8, "DUPLEX_MODE"),
    (7, "COLLISION_TEST"),
    (6, "RES6"),
    (5, "RES5"),
    (4, "RES4"),
    (3, "RES3"),
    (2, "RES2"),
    (1, "RES1"),
    (0, "RES0"),
]

eth_phy_bmsr_bits = [
    (0, "EXTENDED_CAP"),
    (1, "JABBER_DETECT"),
    (2, "LINK_STATUS"),
    (3, "AUTO_NEG_ABILITY"),
    (4, "REMOTE_FAULT"),
    (5, "AUTO_NEG_COMPLETE"),
    (6, "MF_PREAMBLE"),
    (7, "RES1"),
    (8, "RES2"),
    (9, "RES3"),
    (10, "RES4"),
    (11, "10BASE_T_HDX"),
    (12, "10BASE_T_FDX"),
    (13, "100BASE_TX_HDX"),
    (14, "100BASE_TX_FDX"),
    (15, "100BASE_T4"),
]

eth_phy_anar_bits = [
    (15, "NEXT_PAGE_IND"),
    (14, "RES_14"),
    (13, "REMOTE_FAULT"),
    (12, "RES_12"),
    (11, "ASM_DIR"),
    (10, "PAUSE"),
    (9, "T4"),
    (8, "TX_FD"),
    (7, "TX"),
    (6, "_10_FD"),
    (5, "_10"),
    (0, 4, "PROTOCOL_SELECTION")
]

eth_phy_anlpar_bits = [
    (15, "NEXT_PAGE_IND"),
    (14, "ACK"),
    (13, "REMOTE_FAULT"),
    (12, "RES_12"),
    (11, "ASM_DIR"),
    (10, "PAUSE"),
    (9, "T4"),
    (8, "TX_FD"),
    (7, "TX"),
    (6, "_10_FD"),
    (5, "_10"),
    (0, 4, "PROTOCOL_SELECTION")
]

eth_phy_anlparnp_bits = [
    (15, "NEXT_PAGE_IND"),
    (14, "ACK"),
    (13, "MESSAGE_PAGE"),
    (12, "ACK2"),
    (11, "TOGGLE"),
    (0, 10, "CODE"),
]

eth_phy_aner_bits = [
    (5, 15, "RES"),
    (4, "PDF"),
    (3, "LP_NP_ABLE"),
    (2, "NP_ABLE"),
    (1, "PAGE_RX"),
    (0, "LP_AN_ABLE"),
]

eth_phy_annptr_bits = [
    (15, "NEXT_PAGE_IND"),
    (14, "RES_14"),
    (13, "MESSAGE_PAGE"),
    (12, "ACK2"),
    (11, "TOG_TX"),
    (0, 10, "CODE"),
]

regs = {
    "eth.phy.BMCR" : eth_phy_bmcr_bits,
    "eth.phy.BMSR" : eth_phy_bmsr_bits,
    "eth.phy.ANAR" : eth_phy_anar_bits,
    "eth.phy.ANLPAR" : eth_phy_anlpar_bits,
    "eth.phy.ANLPARNP": eth_phy_anlparnp_bits,
    "eth.phy.ANER": eth_phy_aner_bits,
    "eth.phy.ANNPTR": eth_phy_annptr_bits,
}

def _main(argv):
    if len(argv) <= 1:
        print('usage: {} [<reg-name> <reg-value>]...'.format(argv[0]))
        print('regs:')
        for i in regs:
            print('  {}'.format(i))
        sys.exit(1)

    for (name, val_str) in zip(argv[1::2], argv[2::2]):
        v = int(val_str, 0)
        reg = regs[name]
        bits = format_bits(v, reg)
        print('{}=0x{:08X}={}'.format(name, v, bits))

if __name__ == "__main__":
    _main(sys.argv)
