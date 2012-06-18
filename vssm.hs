-- http://graybeardprogrammer.com/?p=1
-- In haskell this time.

data Operation a = Add | Subtract | Multiply | Divide | Push a

test_ops = [ Push 4, Push 3, Subtract, Push 1, Add, Push 5, Multiply ]

process state op =
	let act = case op of
			Add      -> bin (+)
			Subtract -> bin (-)
			Multiply -> bin (*)
			Divide   -> bin (/)
			Push a   -> (:) a
		where bin op (a2:a1:rest) = (op a1 a2) : rest
	in act state

main = print $ show $ foldl process [] test_ops
