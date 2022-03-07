X = foo

export Y_$(X) = bar


all:
	echo "'$${Y_$(X)}'"
