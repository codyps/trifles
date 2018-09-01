from __future__ import print_function,unicode_literals
import gdb

"""
s1
s0
[optional reserved aligner]
7: xPSR
6: pc
5: lr
4: r12
3: r3
2: r2
1: r1
0: r0

lowest address at bottom, highest at top.
can treat SP as an array
"""

def do_x(value):
    return gdb.execute("x {}".format(value), False, True)[:-1]

class Armv7Hf(gdb.Command):
    """Print info on Armv7 exceptions"""
    def __init__(self):
        super(Armv7Hf, self).__init__("armv7_hf", gdb.COMMAND_RUNNING,
                                    gdb.COMPLETE_NONE)

    def invoke(self, arg, _from_tty):
        lr = gdb.parse_and_eval("$lr")
        print("EXC_RETURN (LR) = {}".format(lr))
        if (lr & 0x4) == 0x4:
            sp = gdb.parse_and_eval("$msp")
            print("MSP = {}".format(sp))
        else:
            sp = gdb.parse_and_eval("$psp")
            print("PSP = {}".format(sp))

        u32_t = gdb.lookup_type('uint32_t').pointer()
        sp = sp.cast(u32_t)
        print("xPSR            {:#010x}".format(int(sp[28/4])))
        print("ReturnAddress\n{}".format(do_x(sp[24/4])))
        print("LR (R14)\n{}".format(do_x(sp[20/4])))
        print("R12             {:#010x}".format(int(sp[16/4])))
        print("R3              {:#010x}".format(int(sp[12/4])))
        print("R2              {:#010x}".format(int(sp[8/4])))
        print("R1              {:#010x}".format(int(sp[1])))
        print("R0              {:#010x}".format(int(sp[0])))

        HFSR = gdb.Value(0xE000ED2C).cast(u32_t).dereference()
        print("HFSR    {:#010x}".format(int(HFSR)))
        if HFSR & (1 << 30):
            print('Forced HardFault (other status registers must be examined)')

        CFSR = gdb.Value(0xE000ED28).cast(u32_t).dereference()
        print("CFSR    {:#010x}".format(int(CFSR)))

        vp = gdb.lookup_type('void').pointer()
        if CFSR & (1 << (8)):
            print('Instruction bus error')
        if CFSR & (1 << (8+1)):
            print('Precise data bus error')
        if CFSR & (1 << (8+2)):
            print('Imprecise data bus error')
        if CFSR & (1 << (8+3)):
            print('BusFault on unstacking for a return from exception')
        if CFSR & (1 << (8+4)):
            print('BusFault on stacking for exception entry')
        if CFSR & (1 << (8+7)):
            print('BFAR holds a valid fault address')

            BFAR = gdb.Value(0xE000ED38).cast(u32_t).dereference().cast(vp)
            print("BFAR    {:#010x}".format(int(BFAR)))

            gdb.execute("x *{}".format(int(BFAR)))
            gdb.execute("info line *{}".format(int(BFAR)))


        MMFAR = gdb.Value(0xE000ED34).cast(u32_t).dereference().cast(vp)
        print("MMFAR   {:#010x}".format(int(MMFAR)))

        AFSR = gdb.Value(0xE000ED3C).cast(u32_t).dereference().cast(vp)
        print("AFSR    {:#010x}".format(int(AFSR)))

Armv7Hf()
