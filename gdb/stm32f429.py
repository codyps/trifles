from __future__ import print_function,unicode_literals
import gdb

"""
"""

def do_x(value):
    return gdb.execute("x {}".format(value), False, True)[:-1]

def format_bitfield(value, bitmap):
    f = []
    for (name, first, last) in bitmap:
        ct = last - first + 1
        if ct < 1:
            raise Exception("bitmap entry {} has invalid range [{}:{}]".format(
                name, first, last
            ))
        mask = (1 << ct) - 1
        mask <<= first
        field_value = (mask & value) >> first
        value &= ~mask

        if ct == 1:
            if field_value:
                f.append(name)
        else:
            f.append("{}({:#x})".format(name, int(field_value)))
    if value:
        f.append("{:#x}".format(int(value)))
    return '|'.join(f)

class Stm32Rcc(gdb.Command):
    """Print info on stm32f429 clocks"""
    def __init__(self):
        super(Stm32Rcc, self).__init__("stm32_clock", gdb.COMMAND_RUNNING,
                                    gdb.COMPLETE_NONE)

    def invoke(self, arg, _from_tty):
        RCC = 0x40023800
        FLASH = 0x40023C00
        try:
            u32_t = gdb.lookup_type('uint32_t').pointer()
        except gdb.error:
            u32_t = gdb.lookup_type('u32').pointer()
        RCC_CR = gdb.Value(RCC).cast(u32_t).dereference()
        print("RCC_CR    {:#010x}".format(int(RCC_CR)))

        f = [
            ('PLLSAIRDY', 29, 29),
            ('PLLSAION',  28, 28),
            ('PLLI2SRDY', 27, 27),
            ('PLLI2SON',  26, 26),
            ('PLLRDY',    25, 25),
            ('PLLON',     24, 24),
            ('CSSON',     19, 19),
            ('HSEBYP',    18, 18),
            ('HSERDY',    17, 17),
            ('HSEON',     16, 16),
            ('HSICAL',    8,  15),
            ('HSITRIM',   3,  7),
            ('HSIRDY',    1, 1),
            ('HSION',     0, 0)
        ]
        print(" {}".format(format_bitfield(RCC_CR, f)))

        RCC_PLLCFGR = gdb.Value(RCC + 0x4).cast(u32_t).dereference()
        print("RCC_PLLCFGR {:#010x}".format(int(RCC_PLLCFGR)))

        f = [
            ('PLLQ', 24, 27),
            ('PLLSRC', 22, 22),
            ('PLLP', 16, 17),
            ('PLLN', 6, 14),
            ('PLLM', 0, 5)
        ]
        print(" {}".format(format_bitfield(RCC_PLLCFGR, f)))

        RCC_CFGR = gdb.Value(RCC + 0x8).cast(u32_t).dereference()
        print("RCC_CFGR {:#010x}".format(int(RCC_CFGR)))
        f = [
            ('MCO2', 30, 31),
            ('MCO2PRE', 27, 29),
            ('MCO1PRE', 24, 26),
            ('IS2SRC', 23, 23),
            ('MCO1', 21, 22),
            ('RTCPRE', 16, 20),
            ('PPRE2', 13, 15),
            ('PPRE1', 10, 12),
            ('HPRE', 4, 7),
            ('SWS', 2, 3),
            ('SW', 0, 1),
        ]
        print(" {}".format(format_bitfield(RCC_CFGR, f)))

Stm32Rcc()
