// undo
open util/ordering[Time]

sig Obj {}
sig Time {
	act: lone Action,
	state: set Obj,
	undo, redo: one ChangeSet
}{
	one undo and one redo
}

abstract sig Action {}

sig ChangeSet {
	remove, add: lone Obj,
	undo: ChangeSet -> Time,
	redo: ChangeSet -> Time	
}{
	no remove & add
}

one sig NoChangeSet extends ChangeSet{
}{
	no remove
	no add
	all t: Time {
		undo.t = NoChangeSet
		redo.t = NoChangeSet
	}
	no ~changeset
}

sig Change extends Action{
	changeset: ChangeSet
}

one sig Undo extends Action{}
one sig Redo extends Action{}

pred init(t: Time){
	all s: ChangeSet | s.undo.t = s and s.redo.t = s
	no t.act
	t.undo = NoChangeSet
	t.redo = NoChangeSet
}

pred not_change(t: Time, ss: ChangeSet){
	all s: ss{
		s.undo.t = s.undo.(t.prev)
		s.redo.t = s.redo.(t.prev)
	}
}

pred apply_forward(t: Time, ch: ChangeSet){
	let t' = t.prev {
			ch.remove in t'.state
			ch.add not in t'.state
			t.state = t'.state - ch.remove + ch.add		
	}
}

pred apply_backward(t: Time, ch: ChangeSet){
	let t' = t.prev {
			ch.add in t'.state
			ch.remove not in t'.state
			t.state = t'.state + ch.remove - ch.add		
	}
}

pred step(t: Time){
	let t' = t.prev, a = t.act {
		one a
		a in Change => {
			let ch = a.changeset {
				apply_forward[t, ch]
				ch.undo.t = t'.undo
				ch.redo.t = t'.redo
				t.redo = NoChangeSet
				t.undo = ch
				not_change[t, ChangeSet - ch]
			}
		}
		a in Undo => {
			let ch = t'.undo {
				apply_backward[t, ch]
				t.undo = ch.undo.t
				t.redo = ch
				not_change[t, ChangeSet]
			}
		}
		a in Redo => {
			let ch = t'.redo {
				apply_forward[t, ch]
				t.undo = ch
				t.redo = ch.redo.t
				not_change[t, ChangeSet]
			}
		}
	}
}
fact{
	init[first]
	all t: Time - first | step[t]
}

check {
	let t' = first, t = first.next {
		// いきなりUndoやRedoをしても何も変わらない
		t.act = Redo => t'.state = t.state
		t.act = Undo => t'.state = t.state
	}
	all t: Time - first {
		one (t.act & (Change + Redo)) and one (t.next.act & Undo) =>
		t.prev.state = t.next.state
	}
	all t: Time - first {
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
} for 20
run {
	//#{Time.act & Change} > 1
	//#{ChangeSet} > 1
} for 5
//run {} for 5 but 3 Time
