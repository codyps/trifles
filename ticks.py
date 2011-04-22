def TICK_SCALE(x):
    return x << 2

def NICE_TO_TICKS(nice):
    return TICK_SCALE(20 - nice) + 1

def interate(acc, nice, rounds):
    for rnd in range(0, rounds):
        acc = (acc >> 1) + NICE_TO_TICKS(nice)
    return acc
