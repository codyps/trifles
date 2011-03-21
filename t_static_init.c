struct x {
	int i;
};


/* BAD */
#define I(x) (((x)>3)?((x)-3):(x))

struct x s = I(1);
