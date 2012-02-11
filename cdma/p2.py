from bitstring import BitString, BitArray

# Assumes bs is '0bLSB MSB', so .reverse it before using this
def shift_pr(bs):
	nbs = (bs[27:28] ^ bs[30:31]) + bs[0:30]
	return (bs[30:31], nbs)

def next_codeword(p_sr):
	p = p_sr
	cw = BitArray(256)

	for i in range(0,256):
		b, p = shift_pr(p)
		print b, p, cw
		cw   = b + cw[0:254]

	return (cw, p)
