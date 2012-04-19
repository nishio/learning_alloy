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

pred change_state (
	p1 : Man, p2 : Woman,
	t, t': Time,
	before, after : State){
		p1.state.t = before
		p2.state.t = before
		p1.state.t' = after
		p2.state.t' = after
		// others don't change their state
		all other: (Person - p1 - p2) {
			other.state.t = other.state.t'
		}	
}

pred step (t, t': Time) {
	some disj p1 : Man, p2 : Woman {
		change_state[p1, p2, t, t', NotMarried, Married]
		or
		change_state[p1, p2, t, t', Married, NotMarried]
	}
}

fact Traces {
	init[first]
	all t: Time - last {
		step[t, t.next]
	}
}

run {} for exactly 4 Person, 4 Time
