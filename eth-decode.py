#! /usr/bin/env python
from __future__ import print_function,unicode_literals
import sys
import math

import itertools
#import attr
#from sumtype import sumtype, match


class R1(object):
    def __init__(self, bit_spec):
        self.bit_spec = bit_spec

    def format_bits(self, val):
        format_bits(val, self.bit_spec)

# each field has:
#   - set of bits
#   - name
#   - value decoder

# each register has:
#  - set of fields?

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
            if fv:
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

stm32f7x_flash_cr_bits = R1([
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
])

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

stm32f7_eth_maccr_bits = [
    (25, "CSTF"),
    (23, "WD"),
    (22, "JD"),
    (17, 20, "IFG"),
    (16, "CSD"),
    (14, "FES"),
    (13, "ROD"),
    (12, "LM"),
    (11, "DM"),
    (10, "IPCO"),
    (9, "RD"),
    (7, "APCS"),
    (5, 7, "BL"),
    (4, "DC"),
    (3, "TE"),
    (2, "RE"),
]

stm32f7_eth_macffr_bits = [
    (31, "RA"),
    (10, "HPF"),
    (9, "SAF"),
    (8, "SAIF"),
    (6,8, "PCF"),
    (5, "BFD"),
    (4, "PAM"),
    (3, "DAIF"),
    (2, "HM"),
    (1, "HU"),
    (0, "PM"),
]

stm32f7_eth_dmasr_bits = [
    (29, "TSTS"),
    (28, "PMTS"),
    (27, "MMCS"),
    (23, 26, "EBS"),
    (20, 23, "TPS"),
    (17, 20, "RPS"),
    (16, "NIS"),
    (15, "AIS"),
    (14, "ERS"),
    (13, "FBES"),
    (10, "ETS"),
    (9, "RWTS"),
    (8, "RPSS"),
    (7, "RBUS"),
    (6, "RS"),
    (5, "TUS"),
    (4, "ROS"),
    (3, "TJTS"),
    (2, "TBUS"),
    (1, "TPSS"),
    (0, "TS"),
]

stm32f7_gpio_pupdr = []

for i in range(0, 16):
    stm32f7_gpio_pupdr += [((i*2), (i*2+2), "PUPDR{}".format(i))]
#print("{}".format(stm32f7_gpio_pupdr))

stm32f7_eth_dmamfbocr_bits = [
    (0, 16, "MFC"),
    (16, "OMFC"),
    (17, 28, "MFA"),
    (28, "OFOC")
]

stm32f7_eth_dmabmr_bits = [
    (0, 'SR'),
    (1, 'DA'),
    (2, 7, 'DSL'),
    (7, 'EDFE'),
    (8, 14, 'PBL'),
    (14, 16, 'PM'),
    (16, 'FB'),
    (17, 23, 'RDP'),
    (23, 'USP'),
    (24, 'FPM'),
    (25, 'AAB'),
    (26, 'MB'),
]

stm32f7_eth_dmaomr_bits = [
    (1, 'SR'),
    (2, 'OSF'),
    (3, 5, 'RTC'),
    (6, 'FUGF'),
    (7, 'FEF'),
    (13, 'ST'),
    (14, 17, 'TTC'),
    (20, 'FTF'),
    (21, 'TSF'),
    (24, 'DFRF'),
    (25, 'RSF'),
    (26, 'DTCEFD'),
]

stm32f7_eth_dmaier_bits = [
    (0, 'TIE'),
    (1, 'TPSIE'),
    (2, 'TBUIE'),
    (3, 'TJTIE'),
    (4, 'ROIE'),
    (5, 'TUIE'),
    (6, 'RIE'),
    (7, 'RBUIE'),
    (8, 'RPSIE'),
    (9, 'RWTIE'),
    (10, 'ETIE'),
    (13, 'FBEIE'),
    (14, 'ERIE'),
    (15, 'AISE'),
    (16, 'NISE'),
]

stm32f7_eth_tdes_bits = [
    (0, 'DB'),
    (1, 'UF'),
    (2, 'ED'),
    (3, 7, 'CC'),
    (7, 'VF'),
    (8, 'EC'),
    (9, 'LCO'),
    (10, 'NC'),
    (11, 'LCA'),
    (12, 'IPE'),
    (13, 'FF'),
    (14, 'JT'),
    (15, 'ES'),
    (16, 'IHE'),
    (17, 'TTSS'),
    (20, 'TCH'),
    (21, 'TER'),
    (22, 24, 'CIC'),
    (25, 'TTSE'),
    (26, 'DP'),
    (27, 'DC'),
    (28, 'FS'),
    (29, 'LS'),
    (30, 'IC'),
    (31, 'OWN'),
]

stm32f7_eth_macdbgr_bits = [
    (0, 'MMRPEA'),
    (1, 3, 'MSFRWCS'),
    (4, 'RFWRA'),
    (5, 7, 'RFRCS'),
    (8, 10, 'RFFL'),
    (16, 'MMTEA'),
    (17, 19, 'MTFCS'),
    (19, 'MTP'),
    (20, 22, 'TFRS'),
    (22, 'TFWA'),
    (24, 'TFNE'),
    (25, 'TTF'),
]

eth_phy_phyidr1_bits = [
    (16, 0, "OUI_MSB")
]

eth_phy_phyidr2_bits = [
    (16, 10, "OUI_LSB"),
    (10, 4, "VNDR_MDL"),
    (4, 0, "MDL_REV"),
]

eth_phyext_physts_bits = [
    (14, 'MDIX_MODE'),
    (13, 'RX_ERROR_LATCH'),
    (12, 'POLARITY_STATUS'),
    (11, 'FALSE_CARRIER_SENSE_LATCH'),
    (10, 'SIGNAL_DETECT'),
    (9, 'DESCRAMBLER_LOCK'),
    (8, 'PAGE_RECEIVED'),
    (7, 'MII_INT_PEND'),
    (6, 'REMOTE_FAULT'),
    (5, 'JABBER_DETECT'),
    (4, 'AUTO_NEG_COMPLETE'),
    (3, 'LOOPBACK_ENABLED'),
    (2, 'FULL_DUPLEX'),
    (1, 'SPEED_10'),
    (0, 'LINK_ESTABLISHED'),
]

eth_phy_micr_bits = [
    (0, 'INT_OE'),
    (1, 'INTEN'),
    (2, 'TINT'),
]

eth_phy_misr_bits = [
    (15, 'RESERVED_OR_LINK_QUALITY_INT'),
    (14, 'ENERGY_DETECT_INT'),
    (13, 'LINT_STATUS_INT'),
    (12, 'SPEED_STATUS_INT'),
    (11, 'DUPLEX_STATUS_INT'),
    (10, 'AUTONEG_COMPLETE_INT'),
    (9, 'FALSE_CARRIER_COUNTER_HALF_FULL_INT'),
    (8, 'RECV_ERROR_COUNTER_HALF_FULL_INT'),
    (7, 'RESERVED_ON_LINK_QUALITY_EN'),
    (6, 'ENERGY_DETECT_EN'),
    (5, 'LINK_STATUS_EN'),
    (4, 'SPEED_STATUS_EN'),
    (3, 'DUPLEX_STATUS_EN'),
    (2, 'AUTONEG_COMPLETE_EN'),
    (1, 'FALSE_CARRIER_COUNTER_HALF_FULL_EN'),
    (0, 'RECV_ERROR_COUNTER_HALF_FULL_EN'),
]

eth_phy_pcsr_bits = [
    (12, 'RESERVED_MUST_BE_ZERO'),
    (11, 'FREE_CLK'),
    (10, 'TQ_EN'),
    (9, 'SD_FORCE_PMA'),
    (8, 'SD_OPTION'),
    (7, 'DESC_TIME'),
    (6, 'RESERVED_MUST_BE_ZERO2'),
    (5, 'FORCE_100_OK'),
    (4, 'RESERVED_MUST_BE_ZERO3'),
    (3, 'RESERVED_MUST_BE_ZERO4'),
    (2, 'NRZI_BYPASS'),
    (1, 'RESERVED_MUST_BE_ZERO5'),
    (0, 'RESERVED_MUST_BE_ZERO6'),
]

regs = {
    "armv7m.DFSR": armv7m_dfsr_bits,
    "armv7m.HFSR": armv7m_hfsr_bits,
    "armv7m.DHCSR": armv7m_dhcsr_bits,
    "armv7m.xPSR": armv7m_xpsr_bits,
    "armv7m.UFSR": armv7m_ufsr_bits,
    "armv7m.CFSR": armv7m_cfsr_bits,

    "eth.phy.BMCR" : eth_phy_bmcr_bits,
    "eth.phy.BMSR" : eth_phy_bmsr_bits,
    "eth.phy.PHYIDR1": eth_phy_phyidr1_bits,
    "eth.phy.PHYIDR2": eth_phy_phyidr2_bits,
    "eth.phy.ANAR" : eth_phy_anar_bits,
    "eth.phy.ANLPAR" : eth_phy_anlpar_bits,
    "eth.phy.ANLPARNP": eth_phy_anlparnp_bits,
    "eth.phy.ANER": eth_phy_aner_bits,
    "eth.phy.ANNPTR": eth_phy_annptr_bits,

    "eth.phy.PHYSTS": eth_phyext_physts_bits,
    "eth.phy.MICR": eth_phy_micr_bits,
    "eth.phy.MISR": eth_phy_misr_bits,
    "eth.phy.PCSR": eth_phy_pcsr_bits,

    "stm32f7.eth.MACCR": stm32f7_eth_maccr_bits,
    "stm32f7.eth.MACFFR": stm32f7_eth_macffr_bits,
    "stm32f7.eth.DMASR": stm32f7_eth_dmasr_bits,
    "stm32f7.eth.DMAOMR": stm32f7_eth_dmaomr_bits,
    "stm32f7.eth.DMAMFBOCR": stm32f7_eth_dmamfbocr_bits,
    "stm32f7.eth.DMABMR": stm32f7_eth_dmabmr_bits,
    "stm32f7.eth.DMAIER": stm32f7_eth_dmaier_bits,
    "stm32f7.eth.TDES": stm32f7_eth_tdes_bits,
    "stm32f7.eth.MACDBGR": stm32f7_eth_macdbgr_bits,

    "stm32f7.gpio.PUPDR": stm32f7_gpio_pupdr,
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
