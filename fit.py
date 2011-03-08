#! /usr/bin/env python

def gen_fit(in_range, out_range):
    in_min, in_max = in_range
    out_min, out_max = out_range
    
    out_len = out_max - out_min
    in_len = in_max - in_min

    def fit(in_val):
        return (in_val - in_min) * out_len / in_len + out_min

    return fit

def fit(in_val):
    return in_val / (0xffffffff / 20)
