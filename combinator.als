open util/ordering[Term]

some abstract sig Term {}

one sig K extends Term {}

sig Apply extends Term {
	f, g: Term
}

fact {
	all x, y: Term | (x -> y) in (f + g) => y not in (x.prevs + x)
}

pred equal (x, y: Term) {
	x in Apply and x.f in Apply and x.f.f = K and y = x.f.g
}

fun apply(x, y: Term): Term{	
	{a: Apply | a.f = x and a.g = y }
}

run {
	some x, y: Term | equal[x, y]
} for 5 Term
