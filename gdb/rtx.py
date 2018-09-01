from __future__ import print_function,unicode_literals
import gdb

"""
psp (from r0)
exc_return (from lr)

???

...
s1
s0
[optional reserved aligner]
F: xPSR
E: pc
D: lr
C: r12
B: r3
A: r2
9: r1
8: r0: sp points to this position before exception return
7: r4
6: r5
5: r6
4: r7
3: r8
2: r9
1: r10
0: r11 : sp points to this position in the stack after context save

lowest address at bottom, highest at top.
can treat SP as an array
"""


class Rtx(object):
    def __init__(self):
        pass

    def version(self):
       pass 

class RtxVersion(gdb.Command):
    def __init__(self):
        super(RtxVersion, self).__init__("rtx-version", gdb.COMMAND_RUNNING)

class Context(object):
    def __init__(self, *argv):
        if len(argv) == 0:
            self.pc = None
            self.lr = None
            self.sp = None
        elif len(argv) == 3:
            self.pc = argv[0]
            self.lr = argv[1]
            self.sp = argv[2]
        else:
            raise "invalid number of context args"

    def save(self):
        self.pc = gdb.parse_and_eval('$pc')
        self.sp = gdb.parse_and_eval('$sp')
        self.lr = gdb.parse_and_eval('$lr')

    def restore(self):
        try:
            gdb.parse_and_eval("$pc=%d" % (self.pc))
        except Exception as e:
            raise gdb.GdbError("Could not set `pc`: {}".format(e))
        try:
            gdb.parse_and_eval("$sp=%d" % (self.sp))
        except Exception as e:
            raise gdb.GdbError("Could not set `sp`: {}".format(e))
        try:
            gdb.parse_and_eval("$lr=%d" % (self.lr))
        except Exception as e:
            raise gdb.GdbError("Could not set `lr`: {}".format(e))

def rtx_bt(thread_arg):
    thread_t = gdb.lookup_type("osRtxThread_t").pointer()
    u32_t = gdb.lookup_type("uint32_t")
    tthread_t = thread_arg.type.target().unqualified().pointer()
    if tthread_t != thread_t:
        raise gdb.GdbError("rtx-bt argument is not a osRtxThread_t: '{}' != "
                           "'{}'".format(tthread_t, thread_t))
    if thread_arg == 0:
        raise gdb.GdbError("thread is NULL")

    thread = thread_arg.cast(thread_t).dereference()
    stack = thread['sp'].cast(u32_t.pointer())
    pc = stack[0xE]
    lr = stack[0xD]
    sp = stack + 0
    new_ctx = Context(pc, lr, sp)
    old_ctx = Context()
    old_ctx.save()

    new_ctx.restore()
    gdb.execute("bt")
    old_ctx.restore()


class RtxBt(gdb.Command):
    def __init__(self):
        super(RtxBt, self).__init__("rtx-bt", gdb.COMMAND_RUNNING,
                                    gdb.COMPLETE_EXPRESSION)

    def invoke(self, arg, from_tty):
        args = gdb.string_to_argv(arg)
        if len(args) != 1:
            raise gdb.GdbError("rtx-bt takes 1 osRtxThread_t argument")
        thread_arg = gdb.parse_and_eval(args[0])
        rtx_bt(thread_arg)

RtxBt()

def thread_state(value):
    status = ['inactive', 'ready', 'running', 'blocked', 'terminated' ]

    if value == -1:
        return 'error'

    vl = value & 0xf
    vh = (value & 0xf0) >> 4
    try:
        s1 = status[vl]
    except IndexError:
        s1 = "unknown({})".format(vl)

    wait = ['', 'delay', 'join', 'thread_flags', 'event_flags', 'mutex',
            'semaphore', 'memory_pool', 'message_get', 'message_put']
    if vh == 0:
        return s1

    try:
        s2 = wait[vh]
    except IndexError:
        s2 = "unknown({})".format(vh)

    return "{}|{}".format(s1, s2)


class RtxThreads(gdb.Command):
    """List all RTX threads"""
    def __init__(self):
        super(RtxThreads, self).__init__("info rtx-threads", gdb.COMMAND_STACK,
                                         gdb.COMPLETE_NONE)
        self.u32_t = gdb.lookup_type("uint32_t")

    def _pone(self, thread):
        vp = gdb.lookup_type('void').pointer()
        u32_t = self.u32_t
        stack = thread['sp'].cast(u32_t.pointer())
        pc = stack[0xE]

        try:
            pc = int(pc)
        except gdb.error:
            pc = int(str(pc).split(None, 1)[0], 16)

        thread_id = thread['id']
        tname = thread['name']
        if tname == 0:
            name = "(NULL)"
        else:
            name = str(thread['name']).split(None, 1)[1]
        x = gdb.execute("x/i {}".format(pc), False, True)[:-1]
        print("{:#x} {} {}: {}".format(
            int(thread), name, thread_state(thread['state']), x))

    def _plist(self, tlist, next_field):
        while tlist != 0:
            self._pone(tlist)
            tlist = tlist[next_field]

    def invoke(self, _arg, _from_tty):

        tctx = gdb.parse_and_eval('osRtxInfo.thread');
        print("# Curr: ")
        self._pone(tctx['run']['curr'])
        print("# Next: ")
        self._pone(tctx['run']['next'])
        print("# Delay:")
        self._plist(tctx['delay_list'], 'delay_next')
        print("# Wait:")
        self._plist(tctx['wait_list'], 'delay_next')
        print("# Idle:")
        self._pone(tctx['idle'])

RtxThreads()

def find_thread(thread_id):
    thread_p = gdb.lookup_type('osRtxThread_t').pointer()
    thread = thread_id.cast(thread_p)

    u32_t = gdb.lookup_type("uint32_t")
    stack = thread['sp'].cast(u32_t.pointer())
    return (stack[0xE], stack + 0x8)

class RtxThread(gdb.Command):
    """Run a gdb command in the context of a Rtx thread"""
    def __init__(self):
        super(RtxThread, self).__init__("rtx-thread", gdb.COMMAND_STACK,
                                         gdb.COMPLETE_NONE)
        self.u32_t = gdb.lookup_type("uint32_t")

    def invoke(self, arg, _from_tty):
        thread_id, cmd = arg.split(None, 1)
        thread_id = gdb.parse_and_eval(thread_id)

        pc, sp = find_thread(thread_id)
        if not pc:
            print("No such thread: ", thread_id)
            return

        try:
            pc = int(pc)
        except gdb.error:
            pc = int(str(pc).split(None, 1)[0], 16)

        save_frame = gdb.selected_frame()
        gdb.parse_and_eval('$save_sp = $sp')
        gdb.parse_and_eval('$save_pc = $pc')
        gdb.parse_and_eval('$sp = {}'.format(str(sp)))
        gdb.parse_and_eval('tbreak {}'.format(str(pc)))
        gdb.parse_and_eval('jump *{}'.format(str(pc)))

        try:
            gdb.execute(cmd)
        finally:
            gdb.parse_and_eval('$sp = $save_sp')
            gdb.parse_and_eval('tbreak $save_pc')
            gdb.parse_and_eval('jump $save_pc')
            save_frame.select()

RtxThread()
