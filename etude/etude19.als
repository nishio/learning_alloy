sig X{
	r1: X
	r2: X
}

run {
	all x: X | x != x.r
} for exactly 3 X
