#! /usr/bin/env python
from __future__ import print_function

from sys import argv, stdin, exit

levels = [
        "All", # fake
        "Device", # 0
        "Configuration", # 1
        "Interface", # 2
        "Endpoint", # 3
        "Nothing" # fake
        ]

def usage():
    print('usage: usb_desc')
    exit(0)

class Section():
    def __init__(self, parent = None, indent = None):
        self.parent = parent
        self.indent = indent
        self.secs   = []
        self.attrs  = []

    def __repr__(self):
        sa = ''
        for a in self.attrs:
            sa = sa + '\n\t' + repr(a) + ','
        ss = ''
        for s in self.secs:
            ss = ss + '\n\t' + repr(s) + ','
        return 'Section( [' + sa + '\n], \n[ ' + ss + ' \n] )'

    def add_subsection(self):
        s = self.__class__()
        self.secs.append(s)
        #print('||{} - {}'.format(s, self))
        return s

    def add_attr(self, name, value, comment):
        #print(' add attr: "{}" "{}" "{}"'.format(name, value, comment))
        self.attrs.append((name, value))

    def needs_indent(self, spaces):
        if self.indent is None:
            self.indent = spaces
            return True
        else:
            return False

    def add_comment(self, comments):
        #print(' add comment to prev attr {} : {}'.format(self.attrs[-1], comments))
        pass

def parse_as_attr(s):
    sp = s.split()
    try:
        n = sp[0]
    except IndexError:
        n = None

    try:
        v = sp[1]
    except IndexError:
        v = None

    try:
        c = ' '.join(sp[2:])
    except IndexError:
        c = None
    return (n, v, c)

S_EXPECT_BUS = 0
S_SECTIONS = 1

class ParseState():
    def __init__(self):
        self.devices = []
        self.curr_section = None
        self.state = S_EXPECT_BUS

    def line_is_bus(self, line):
        if line.startswith("Bus"):
            self.curr_section = cs = Section()
            self.devices.append(cs)
            self.state = S_SECTIONS
            return True
        else:
            return False

    def s_sections(self, line):
        if self.line_is_bus(line):
            return
        else:
            cs = self.curr_section
            stripped_line = line.lstrip()
            spaces = len(line) - len(stripped_line)
            indent = cs.indent
            is_section = stripped_line.endswith(':')
            #print('indent={} spaces={}'.format(indent,spaces))

            if indent is None:
                cs.indent = spaces
                indent = spaces

            if   indent < spaces:
                cs.add_comment(stripped_line)
                #print('comment')
                return
            elif indent > spaces:
                # We can drop multiple sections at once.
                # When a line's spacing doesn't match up to a particular
                # section, use the section that has an indent right below the
                # line's spacing.
                prev_section = cs
                while True:
                    cs = cs.parent
                    if cs is None:
                        self.curr_section = cs = prev_section
                        indent = cs.indent
                        break
                    prev_section = cs
                    indent = cs.indent
                    #print(' }}}')
                    if indent == spaces:
                        break
                    elif indent <= spaces:
                        cs = prev_section
                        indent = cs.indent
                        break
                self.curr_section = cs
                # this line could be a new section starting right after the old one ended.

            if is_section:
                #print(' {{{')
                self.curr_section = cs.add_subsection()
                #print('section')
                return # new sections don't have attributes on the same line

            cs.add_attr(*parse_as_attr(stripped_line))

    def parse_line(self, line):
        if not len(line.strip()):
            return
        if self.state == S_EXPECT_BUS:
            if self.line_is_bus(line):
                return
            else:
                raise Exception("parse error")
        elif self.state == S_SECTIONS:
            self.s_sections(line)
        else:
            raise Exception("invalid parse state")

def main(argv):
    if len(argv) != 1:
        usage()
    ps = ParseState()
    with stdin as f:
        for line in f:
            line = line[:-1]
            print('|{}'.format(line))
            ps.parse_line(line)

    print(repr(ps.devices[0]))

if __name__ == '__main__':
    main(argv)
