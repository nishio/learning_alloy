open util/ordering[Time]

sig Time {}
one sig Person {
	state: State -> Time
}

enum State {Green, Yellow, Red}

pred step (t, t' : Time, s: State){
  Person.state.t in Green => Person.state.t' in Green + Yellow
  Person.state.t in Yellow => Person.state.t' in Red
  Person.state.t in Red => Person.state.t' in Green + Red
}

fact {
  all t: Time {
    one Person.state.t
  }
  all s: State {
		some s <: Person.state
  }
}

fact Traces {
	all t: Time - last {
		let t' = t.next {
			all s: State {
				step [t, t', s]
      }
		}
	}
}

run {
} for 5 Time
