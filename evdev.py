#! /usr/bin/env python
from __future__ import print_function
import evdev

device = evdev.InputDevice('/dev/input/event1')
for event in device.read_loop():
    if event.type == evdev.ecodes.EV_KEY:
        e = categorize(event)
        if e.keycode == evdev.ecodes.KEY_A:
            print("Got A!")
