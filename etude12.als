// puzzle

enum Truth {T, F}

abstract sig Pred {
}

sig X_IS_LIER extends Pred {
	who: Person
}
sig X_IS_LIE extends Pred {
	x: Pred
}

sig Person {
	said: Pred
}

fact {
}

run {
	one {truth: Pred -> Truth |
		(all p: X_IS_LIE {p.truth = T => p.x.truth = F})
		and	(all p: X_IS_LIER {p.truth = T => p.who.said.truth = F})
	}
}
