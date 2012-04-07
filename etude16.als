open util/ordering[Time]
open named_man_ja [Man]
open named_woman_ja [Woman]

sig Time {}

abstract sig Person {
	state: State -> Time,
}

abstract sig Man, Woman extends Person {}

enum State {Married, NotMarried}

pred init (t: Time) {
	all p: Person | p.state.t = NotMarried
}

pred step (t, t': Time) {
	some disj p1 : Man, p2 : Woman {
		{{
			// marrige
			p1.state.t = NotMarried and p2.state.t = NotMarried
			p1.state.t' = Married and p2.state.t' = Married
		} or {
			// divorce
			p1.state.t = Married and p2.state.t = Married
			p1.state.t' = NotMarried and p2.state.t' = NotMarried
		}}
		// others don't change their state
		let others = (Person - p1 - p2) {
			others.state.t = others.state.t'
		}
	}
}

fact Traces {
	init[first]
	all t: Time - last {
		step[t, t.next]
	}
}

run {} for 3 Person, 5 Time
