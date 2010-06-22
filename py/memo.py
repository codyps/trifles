#!/usr/bin/env python3
import pickle

def memoize(fn):
	cache = {} # a dict of return values indexed via arguments.
	def memo_fn(*gook, **kwargs):
		pick_args = pickle.dumps((gook,kwargs))
		if pick_args in cache:
			return cache[pick_args]
		else:
			val = fn(*gook,**kwargs)
			cache[pick_args] = val
			return val

	memo_fn.__name__ = fn.__name__
	#memo_fn.__code__.co_argcount = fn.__code__.co_argcount
	#memo_fn.__code__.co_varnames = fn.__code__.co_varnames
	#memo_fn.__code__.co_kwonlyargcount = fn.__code__.co_kwonlyargcount

	return memo_fn

@memoize
def fib(x):
	if x < 2:
		return 1
	else:
		return fib(x-1)+fib(x-2)


if __name__ == "__main__":
	print( fib(30))

#a, b = 0, 1
#while b < 10:
#	print(b,end=' ')
#	a, b = b, a+b
#print()
