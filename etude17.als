open util/ordering[Time]
open named_man_ja [Man]
open named_woman_ja [Woman]

sig Time {
	event: lone Event
}

fact {
	no first.event
	all t: Time - first {one t.event}
}

abstract sig Person {
	state: State -> Time,
	partner: Person -> Time,
	parent_bio: set Person
}{
	all t: Time | one state.t
	all t: Time | lone partner.t
	let p = parent_bio {
		no p or 
		{state.first = NotExist and state.last != NotExist}
	}
}

abstract sig Man, Woman extends Person {}

enum State {NotExist, Married, NotMarried}

enum Event {Marriage, Divorce, Birth}


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
		{
			t'.event = Marriage
			change_state[p1 + p2, t, t', NotMarried, Married]
		} or {
			t'.event = Divorce
			change_state[p1 + p2, t, t', Married, NotMarried]
		}
	}} 
	or
	some p: Person {
		// birth
		//t'.event = Birth
		change_state[p, t, t', NotExist, NotMarried]
		some father: p.parent_bio & Man {father.state.t != NotExist}
		some mother: p.parent_bio & Woman {mother.state.t != NotExist}
	}
}

fact Traces {
	init[first]
	all t: Time - last {
		step[t, t.next]
	}
}

run {
	some parent_bio
} for exactly 4 Person, 4 Time
