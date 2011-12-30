#! /usr/bin/env python
from __future__ import division,print_function

import sys, random

discard = []

DRAW_FROM_PILE, DRAW_FROM_DISCARD = 0, 1

class Players(object):
	def __init__(self, name, control, feedback):
		self.name = name
		self.control = control
		self.feedback = feedback

class Game(object):
	def __init__(self, players, param):
		self.players = players
		self.param   = param

		self.draw_pile    = []
		self.hands        = []
		self.discard_pile = []
		self.turn         = 0

	def deal(self):
		pass


	def run_act_hooks(self,
			cur_p_name, turn, old_discard,
			new_discard,
			action, card):
		pass

	def draw_card(self):
		return self.draw_pile.pop()

	def draw_discard(self):
		return self.discard_pile.pop()

	def place_on_discard(self, card):
		self.discard_pile.insert(0, discard)

	def next_turn(self):
		p = self.players
		h = self.hands
		turn = self.turn

		old_discard_pile = d = self.discard_pile[:]
		cur_p = p[turn]
		cur_h = h[turn]

		act = cur_p.take_action(cur_h, turn, d)

		if act is DRAW_FROM_DISCARD:
			card = self.draw_discard()
			d = self.discard_pile[:]
		elif act is DRAW_FROM_PILE:
			card = self.draw_card()
		else:
			raise OMG()

		swap_position = cur_p.swap_and_discard_action(cur_h, turn, d, card)
		discard = cur_h[swap_position]
		cur_h[swap_position] = card

		self.run_act_hooks(cur_p.name,
				   turn,
				   old_discard_pile,
				   d,
				   act,
				   card)

		# POSSIBLE: validate discard & new hand, only allow
		self.place_on_discard(discard)

class Player(object):
	"""
	Feedback & Interaction methods
	"""
	def __init__(self):
		self.d = None

	def act_hook(cur_player_name, turn_num, old_discard, new_discard,
			action, card):
		pass

	def take_action(hand, turn, discard_pile):
		# or DRAW_FROM_DISCARD
		return DRAW_FROM_PILE

	def swap_and_discard_action(hand, turn, discard_pile, card):
		return 0

class GameKnowledge(object):
	"""
	The current collection of information about how the cards lay
	(who has what, picked up what, played what, discarded what
	"""

	def __init__(self, players):
		"""
		discard = initial discard pile (1 card, probably)
		players = list of players (unique hashable ids)
		"""
		self.players = players
		self.discard = discard
		self.turns = 0

	def _discard_pile(self):
		"""
		return the current discard pile's contents
		"""
		return self.discard

	def update_with_new_discard(pile):
		"""
		We haven't been watching closely, all we know is that
		it is our turn now.
		"""

	def update_with_play(player, draw, discard, card=None):
		"""
		player = unique hashable id (string, probably).
		draw = DRAW_FROM_PILE or DRAW_FROM_DISCARD
		discard = new discard pile (their card on top)
		"""

class Hand(list):
	"""
	Maybe?
	Does a hand need methods a list lacks?
	- swap a card?
	"""
	pass

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


def list_append_tail(lst, elem):
	l = lst[:]
	l.append(elem)
	return l

def list_append_head(elem, lst):
	l = lst[:]
	l.insert(0, elem)
	return l

def card_P(hand, game_knowledge):
	"""
	return an list of probabilities of filling each of the respective
	slots
	"""
	#discard = game_knowledge.discard_pile()

	hi_slots = list_append_tail(cards , max_card)
	lo_slots = list_append_head(min_card, cards)

	p = [ (s_hi - s_lo) / (max_card - min_card + 1) for s_hi in hi_slots for s_lo in lo_slots ]

	# FIXME: does not use the info from the discard pile at all.
	return p

def median_P(hand, game_knowledge):
	"""
	median of the probabilities that the slot will be filled next turn
	"""
	p = card_P(hand, game_knowledge)

	pz = zip(p, range(min_card, max_card))

	



def place_card(slots, discard, card):
	"""
	slots[1] - min_card
	slots[2] - slots[1]
	...
	max_card - slots[-1]
	"""

	# filter out slots that work already??

	cards = [ s.card for s in slots ]
	return min(p)
