{-
rev1 (x:xs) = r xs : []
	where
		r (x:[]) = x
		r (x:xs) = r xs : x
-}

foldl_ fn i (x:[]) = fn i x
foldl_ fn i (x:xs) = foldl_ fn (fn i x) xs


rev2 = foldl (flip (:)) []
