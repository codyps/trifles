module Rako (make_deck,make_deck_basic,basic_param) where

import Data.Random
import Data.Random.List (shuffleN)

data Param = Param { max_card :: Int, min_card :: Int, slot_values :: [Int] }

ct_cards param =
	max_card param - min_card param

basic_param = Param 60 1 [5, 10, 15, 20, 25, 30, 35, 40, 45, 50]

make_deck_basic = make_deck basic_param

make_deck :: Param -> RVar [Int]
make_deck param =
	let n = [ min_card param .. max_card param ] in
	shuffleN (ct_cards param) n

make_one_deck :: Param -> IO [Int]
make_one_deck param =
	runRVar (make_deck param)
