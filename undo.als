// undo
open util/ordering[Time]

sig Time {
	act: lone Action,
	state: State
}

abstract sig Action {}

sig Change extends Action{
	before: State,
	after: State
}{
	before != after
}
one sig Undo extends Action{}
one sig Redo extends Action{}

sig State {
	undo: State -> Time,
	redo: State -> Time
}{
	all t: Time | one undo.t and one redo.t
}

pred init(t: Time){
	all s: State | s.undo.t = s and s.redo.t = s
	no t.act
}

pred not_change(t: Time, ss: State){
	all s: State{
		s.undo.t = s.undo.(t.prev)
		s.redo.t = s.redo.(t.prev)
	}
}

pred step(t: Time){
	let t' = t.prev, a = t.act {
		one a
		a in Change => {
			t'.state = a.before
			t.state = a.after
			t.state.undo.t = a.before
			t.state.redo.t = t.state.redo.t' // keep
			not_change[t, State - t.state]
		}
		a in Undo => {
			t.state = t'.state.undo.t'
			t.state.undo.t = t.state.undo.t' // keep
			t.state.redo.t = t'.state
			not_change[t, State - t.state]
		}
		a in Redo => {
			t.state = t'.state.redo.t'
			not_change[t, State]
		}
	}
}
fact{
	init[first]
	all t: Time - first | step[t]
}
check {
	all t: Time {
		one (t.act & (Change + Redo)) and one (t.next.act & Undo) =>
		t.prev.state = t.next.state
	}
	all t: Time {
		one (t.act & Undo) and one (t.next.act & Redo) =>
		t.prev.state = t.next.state
	}
	all t: Time {
		one (t.act & (Change + Redo)) and 
		one (t.next.act & (Change + Redo)) and
		one (t.next.next.act & Undo) and
		one (t.next.next.next.act & Undo)
		=>
		t.prev.state = t.next.next.next.state
	}

} for 10
//run {} for 5 but 3 Time
