open util/ordering[Term]

some abstract sig Term {}

one sig S, K extends Term {}

sig Apply extends Term {
	f, g: Term
}

fact {
	all x, y: Term | (x -> y) in (f + g) => y in x.nexts
}

pred equal_k (x, y: Term) {
	one a, b: Term | x = apply[apply[K, a], b] and y = a
}

pred equal_s (x, y: Term) {
	one a, b, c: Term {
		x = apply[apply[apply[S, a], b], c]
		and
		y = apply[apply[a, c], apply[b, c]]
	}
}

pred equal (x, y: Term) {
	equal_k[x, y] or equal_s[x, y] or 
	one z: Term | equal[x, z] and equal[z, y]
}

fun apply(x, y: Term): Term{	
	{a: Apply | a.f = x and a.g = y }
}

fact {
	all x, y: Term | lone apply[x, y]
}

run {
	some I: Term | all x: Term | equal[apply[I, x], x]
	//one apply[apply[apply[S, K], K], S]
	
} for 5 Term
