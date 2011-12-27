#! /usr/bin/env python
from __future__ import division,print_function

import sys, random

discard = []


DRAW_FROM_PILE, DRAW_FROM_DISCARD = 0, 1

class Slot(object):
	def __init__(self, val, card = None):
		self.val = val
		self.card = card
	def __str__(self):
		return '{0}: {1}'.format(self.val,self.card)
	def __repr__(self):
		return 'Slot({0},{1})'.format(self.val,self.card)

class Param(object):
	# Basic
	max_card = 60
	min_card = 1
	slot_values = [ 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]

	# Computed
	card_range = range(min_card, max_card)
	slot_ct = len(slot_values)
	slots = [ Slot(v) for v in slot_values ]

p = Param()

class Deck(object):
	def __init__(self, param):
		self.cards = range(param.min_card, param.max_card)
		# XXX uses side effects.
		random.shuffle(self.cards)
	def draw(self):
		r = self.cards[0]
		# XXX produces side effects.
		self.cards = self.cards[1:]
		return r

def iif(pred, itrue, ifalse):
	if pred:
		return itrue()
	else:
		return ifalse()

class Hand(object):
	def __init__(self, param):
		self.slots = [ Slot(v) for v in param.slot_values ]

	def give_delt_card(self, card):
		spaces = ifilter(lambda slot: slot.card == None, self.slots)
		if len(spaces) == 0:
			raise RunTimeException('No space for card')
		# XXX produces side effects.
		spaces[0].card = card
		return self
	def __str__(self):

		## s.card is a string without this???
		for s in self.slots:
			s.card = 0

		return '\n'.join((
		''.join(['{0:3d}'.format(s.val)  for s in self.slots]),
		''.join([
			iif(s != None, lambda: '{0:3d}'.format(s.card), lambda: ' * ')
			for s in self.slots
			])
		))

def make_players(param, ct):
	return [ Hand(param) for i in range(0, ct) ]

def deal_to(deck, players, param):
	for i in param.slot_ct:
		for p in players:
			c = deck.draw()
			p.give_delt_card(c)

def score(slots):
	i  = 0
	sc = 0
	for s in slots:
		if s.card < i:
			i  = s.card
			sc = s.val

def draw_or_swap(discard, slots):
	d = discard[0]

def print_hand(slots, file=sys.stdout):
	for s in slots:
		print('{0:3d}'.format(s.val), end='', file=file)
	print()
	for s in slots:
		print('{0:3d}'.format(s.card), end='', file=file)
	print()

def slot_low_hi(ix):
	card_per_slot = (max_card - min_card + 1) / slot_ct
	low = ix * card_per_slot + min_card
	return (low, low + card_per_slot - 1)

def bucket(slots, discard):
	d = discard[0]
	for (s, i) in zip(slots,range(0,len(slots))):
		low, hi = slot_low_hi(i)
		if (not low < s.card < hi) and (low < d < hi):
			return DRAW_FROM_DISCARD
	return DRAW_FROM_PILE

def bucket_and_close(slots, discard):
	d = discard[0]
	for (s, i) in zip(slots,range(0,len(slots))):
		low, hi = slot_low_hi(i)
		if (not low < s.card < hi) and (low < d < hi):
			return DRAW_FROM_DISCARD
	return DRAW_FROM_PILE
