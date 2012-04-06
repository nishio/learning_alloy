open util/ordering[Term]

some abstract sig Term {}

one sig K extends Term {}

sig Apply extends Term {
	f, g: Term
}

fact {
	all x, y: Term | (x -> y) in (f + g) => y not in (x.prevs + x)
}

pred equal_k (x, y: Term) {
	x in Apply and x.f in Apply and x.f.f = K and y = x.f.g
}
pred equal_k2 (x, y: Term) {
	one a, b: Term | x = apply[apply[K, a], b] and y = a
}
check {
	some x, y: Term | equal_k[x, y] iff equal_k2[x, y]
}

//pred equal_s (x, y: Term) {}
pred equal (x, y: Term) {
	equal_k[x, y]// or equal_s[x, y]
}

fun apply(x, y: Term): Term{	
	{a: Apply | a.f = x and a.g = y }
}

fact {
	all x, y: Term | lone apply[x, y]
}

run {
	some x, y: Term | equal[x, y]
} for 5 Term
