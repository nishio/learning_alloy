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
	parent_bio: set Person,
  parent_think: set Person
}{
	all t: Time | one state.t
	all t: Time | lone partner.t
	let p = parent_bio {
		no p or born_in_scope
  }
	let p = parent_think {
		no p or born_in_scope
  }
}

pred born_in_scope(p: Person){
	p.state.first = NotExist
	p.state.last != NotExist
}

abstract sig Man, Woman extends Person {}

enum State {NotExist, Married, NotMarried}

enum Event {Marriage, Divorce, Birth}


pred init (t: Time) {
	all p: Person | p.state.t in NotMarried + NotExist
	all p: Person | p.partner.t = none
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

pred keep_partner(others: Person, t, t': Time){
	all other: others {
		other.partner.t = other.partner.t'
	}	
}
pred step (t, t': Time) {
	{some disj p1 : Man, p2 : Woman {
		{
			t'.event = Marriage
			change_state[p1 + p2, t, t', NotMarried, Married]
			p1.partner.t' = p2
			p2.partner.t' = p1
			keep_partner[Person - p1 - p2, t, t']
		} or {
			t'.event = Divorce
			change_state[p1 + p2, t, t', Married, NotMarried]
			p1.partner.t' = none
			p2.partner.t' = none
			keep_partner[Person - p1 - p2, t, t']
		}
	}} 
	or
	some p: Person {
		// birth
		t'.event = Birth
		change_state[p, t, t', NotExist, NotMarried]
		some father: p.parent_bio & Man {
			one father
			father.state.t != NotExist
		}
		some mother: p.parent_bio & Woman {
			one mother
			mother.state.t != NotExist
			let hasband = mother.partner.t {
				// p always think his biological mother is his mother
				// if mother married, p think mother's hasband is his father
				// no other person is tought as parent
				p.parent_think = mother + hasband
			}
		}
		keep_partner[Person, t, t']
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
	some p: Person {p.parent_bio & Man != p.parent_think & Man}
} for exactly 4 Person, 4 Time
