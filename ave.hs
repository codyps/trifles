--myave :: (Num a) => [a] -> a
myave xs = myave_ xs 0 0

--myave_ :: (Num a, Fractional b) => [a] -> a -> b -> a
myave_ []     acc ct = acc / ct
myave_ (x:xs) acc ct =
	myave_ xs (acc + x) (ct + 1)
