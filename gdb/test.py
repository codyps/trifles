import gdb
class SavePrefixCommand (gdb.Command):
    "Prefix command for saving things"

    def __init__(self):
        super(SavePrefixCommand, self).__init__("save", gdb.COMMAND_SUPPORT, gdb.COMPLETE_NONE, True)

SavePrefixCommand()
