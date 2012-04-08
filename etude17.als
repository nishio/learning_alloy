open util/ordering[Time]
open named_man_ja [Man]
open named_woman_ja [Woman]

sig Time {}

abstract sig Person {
	state: State -> Time,
}{
	all t: Time | one state.t
}

abstract sig Man, Woman extends Person {}

enum State {NotExist, Married, NotMarried}

pred init (t: Time) {
	all p: Person | p.state.t in NotMarried + NotExist
}

pred change_state (
	target : Person,
	t, t': Time,
	before, after : State){
		some target
		all p: target {
			p.state.t = before
			p.state.t' = after
		}
		// others don't change their state
		all other: (Person - target) {
			other.state.t = other.state.t'
		}	
}

pred step (t, t': Time) {
	{some disj p1 : Man, p2 : Woman {
		// marriage
		change_state[p1 + p2, t, t', NotMarried, Married]
		or
		// divorce
		change_state[p1 + p2, t, t', Married, NotMarried]
	}} 
	or
	some p: Person {
		// birth
		change_state[p, t, t', NotExist, NotMarried]
	}
}

fact Traces {
	init[first]
	all t: Time - last {
		step[t, t.next]
	}
}

run {} for exactly 4 Person, 4 Time
