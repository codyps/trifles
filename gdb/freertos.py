import gdb
import gdb.printing

class QueuePrinterRaw(object):
    "Print a Queue_t"
    def __init__(self, val, item_type):
        if val.type.name == 'QueueHandle_t':
            queue_t = gdb.lookup_type('Queue_t').pointer()
            val = val.cast(queue_t)
        self.val = val
        self.item_type = item_type
        self.item_type_p = self.item_type.pointer()

    def item_size(self):
        return self.val['uxItemSize']

    def capacity(self):
        return self.val['uxLength']

    def len(self):
        return self.val['uxMessagesWaiting']

    def read_i(self, i):
        item_size = self.item_size()
        if item_size == 0:
            return None
        if i >= self.len():
            raise "Bad index: {}".format(i)

        item_type_p = self.item_type_p
        rf = self.val['u']['pcReadFrom']
        tail = self.val['pcTail']
        head = self.val['pcHead']
        for z in range(0, i + 1):
            rf += item_size
            if rf >= tail:
                rf = head
        # read `item_size` bytes from `rf`
        item =  rf.cast(item_type_p)
        return item.dereference().dereference()


    def children(self):
        return (('{}'.format(i), self.read_i(i)) for i in range(0, self.len()))

    def to_string(self):
        return 'Queue: len: {}, waiting: {}, item size: {}, total size: {}'.format(
            self.len(),
            self.capacity(),
            self.item_size(),
            self.len() * self.item_size()
        )

    def display_hint(self):
        return 'array'

    def print(self):
        print(self.to_string())
        print("{")
        for i in self.children():
            print("  [{}] = {},".format(i[0], i[1]))
        print("}")

class QueuePrinter(QueuePrinterRaw):
    "Print a Queue_t"

    def __init__(self, val):
        item_type = gdb.lookup_type('struct tmrTimerQueueMessage')
        super(self, val, item_type)


class TaskPrinter(object):
    "Print a TaskHandle_t"

    def __init__(self, val):
        if val.type.name == 'TaskHandle_t':
            real_t = gdb.lookup_type('TCB_t').pointer()
            val = val.cast(real_t)
        self.val = val

    def to_string(self):
        return 'Task { top_of_stack: {} }'.format(self.val['pxTopOfStack'])

class ListPrinter(object):
    "Print a List_t"

    def __init__(self, val, start='HEAD'):
        self.val = val
        self.start = start

    def len(self):
        return self.val['uxNumberOfItems']

    def read_i(self, i):
        if self.start == 'NEXT':
            index = self.val['pxIndex']
        elif self.start == 'HEAD':
            index = self.val['xListEnd']['pxNext']
        else:
            raise "Unknown list start {}".format(self.start)

        for z in range(0, i):
            index = index['pxNext']

        # ListItem_t
        return index.dereference()

    def children(self):
        return (('{}'.format(i), self.read_i(i)) for i in range(0, self.len()))

    def to_string(self):
        return 'List: len: {}, index: {}, end: {}'.format(
            self.len(),
            self.val['pxIndex'],
            self.val['xListEnd'],
        )

    def display_hint(self):
        return 'array'

class FreeRtosTimerQueue(gdb.Command):
    """List all FreeRTOS Timer Queue events"""
    def __init__(self):
        super(FreeRtosTimerQueue, self).__init__("info freertos-timer-queue",
                                             gdb.COMMAND_STATUS)

    def invoke(self, _arg, _from_tty):
        item_type = gdb.lookup_type('DaemonTaskMessage_t').pointer()
        val = gdb.parse_and_eval('xTimerQueue')
        QueuePrinterRaw(val, item_type).print()

FreeRtosTimerQueue()

class FreeRtosTimers(gdb.Command):
    """List all FreeRTOS Timers"""
    def __init__(self):
        super(FreeRtosTimers, self).__init__("info freertos-timers",
                                             gdb.COMMAND_STACK)
        self.timer_t = gdb.lookup_type('Timer_t').pointer()

    def print_timer_list(self, task_list):
        tl = ListPrinter(task_list, start='HEAD')
        print("# {}".format(tl.len()))
        for n,li in tl.children():
            tcb = li['pvOwner'].cast(self.timer_t).dereference()
            print(' {}'.format(tcb))

    def invoke(self, _arg, _from_tty):
        print("timers:")
        self.print_timer_list(gdb.parse_and_eval('pxCurrentTimerList').dereference())

        print("timers overflow:")
        self.print_timer_list(gdb.parse_and_eval('pxOverflowTimerList').dereference())

FreeRtosTimers()

class FreeRtosThreads(gdb.Command):
    """List all FreeRTOS threads"""
    def __init__(self):
        super(FreeRtosThreads, self).__init__("info freertos-threads", gdb.COMMAND_STACK)
        self.tcb_t = gdb.lookup_type('TCB_t').pointer()

    def print_task_list_(self, tl):
        for n,li in tl.children():
            tcb = li['pvOwner'].cast(self.tcb_t).dereference()
            print(' {}'.format(tcb))

    def print_task_list(self, task_list):
        tl = ListPrinter(task_list)
        print("# {}".format(tl.len()))
        self.print_task_list_(tl)

    def print_prio_list(self, task_lists, prio):
        task_list = task_lists[prio]
        tl = ListPrinter(task_list)
        print("prio: {}, count: {}".format(prio, tl.len()))
        self.print_task_list_(tl)

    def invoke(self, _arg, _from_tty):
        ready_task_lists = gdb.parse_and_eval('pxReadyTasksLists')
        max_priorities = int(ready_task_lists.type.sizeof /
                          ready_task_lists.type.target().sizeof)

        print("configMAX_PRIORITIES: {}".format(max_priorities))

        print("ready tasks:")
        for prio in range(max_priorities - 1, -1, -1):
            self.print_prio_list(ready_task_lists, prio)

        print("delayed tasks:")
        self.print_task_list(gdb.parse_and_eval('pxDelayedTaskList').dereference())

        print("delayed tasks overflow:")
        self.print_task_list(gdb.parse_and_eval('pxOverflowDelayedTaskList').dereference())

        print("pending tasks:")
        self.print_task_list(gdb.parse_and_eval('xPendingReadyList'))

FreeRtosThreads()


def build_pretty_printer():
    pp = gdb.printing.RegexpCollectionPrettyPrinter(
        "freertos")

    pp.add_printer('Queue_t', '^Queue_t$', QueuePrinter)
    pp.add_printer('QueueHandle_t', '^QueueHandle_t$', QueuePrinter)
    pp.add_printer('QueueDefinition_t', '^QueueDefinition$', QueuePrinter)

    #pp.add_printer('TCB_t', '^TCB_t$', TaskPrinter)
    #pp.add_printer('TaskHandle_t', '^TaskHandle_t$', TaskPrinter)
    #pp.add_printer('tskTaskContolBlock', '^tskTaskControlBlock$', TaskPrinter)

    pp.add_printer('List_t', '^List_t$', ListPrinter)
    pp.add_printer('xLIST', '^xLIST$', ListPrinter)

    return pp

gdb.printing.register_pretty_printer(
    gdb.current_objfile(),
    build_pretty_printer(),
    replace=True)

class FreeRtosQueuePrint(gdb.Command):
    """Print contents of FreeRtos Queue"""
    def __init__(self):
        super(FreeRtosQueuePrint, self).__init__("p-freertos-queue",
                                              gdb.COMMAND_STATUS,
                                              gdb.COMPLETE_NONE,
                                              gdb.COMPLETE_EXPRESSION)
    def invoke(self, arg, _from_tty):
        item_type = gdb.lookup_type(arg[0])
        queue_printer = QueuePrinterRaw(arg[1], item_type)
        queue_printer.print()

FreeRtosQueuePrint()
