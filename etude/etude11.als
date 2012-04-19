open util/ordering[Term]

some abstract sig Term {}

one sig S, K extends Term {}

sig Apply extends Term {
	f, g: Term
}

fact {
	all x, y: Term | (x -> y) in (f + g) => y not in (x.prevs + x)
}

pred equal (x, y: Term) {
	x in Apply and x.f in Apply and x.f.f = K and y = x.f.g
//	or
//	(x in Apply and x.f in Apply and x.f.f in Apply 
//	 and x.f.f.f = S and x = x.f.g

}

fact {
//	all x: Term | no x.~(f + g) & x.^(f + g)
}

fun apply(x, y: Term): Term{	
	{a: Apply | a.f = x and a.g = y }
}

fact {
//	equal[apply[apply[K, K], K], K]
//	one apply[K, K]
//	one apply[apply[K, K], K]
//	equal[apply[apply[K, K], K], K]
}
run {
//	all x: Term | equal[apply[apply[apply[S, K], K], x], x]
//	some I: Term | all x: Term | equal[apply[I, x], x]
//	some KK: Term | all x: Term | equal[apply[KK, x], K]
	some x, y: Term | equal[x, y]
} for 5 Term
