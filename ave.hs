--myave :: (Fractional a) => [a] -> a
average1 xs = myave_ xs 0 0
	where
		--myave_ :: (Fractional a) => [a] -> a -> b -> a
		myave_ []     acc ct = acc / ct
		myave_ (x:xs) acc ct = myave_ xs (acc + x) (ct + 1)

average2 xs =
	let (acc,ct) =
		foldl (\(acc,ct) x -> (acc + x, ct + 1)) (0,0) xs in
	acc / ct
	
