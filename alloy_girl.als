open util/ordering[Time]
sig Time{}

one sig StateManager {
	state: State -> Time,
	current_state: State -> Time
}{
	// すべての時刻でcurrent_stateは1個
	all t: Time {
		one current_state.t
	}
	// 最初はstateは空っぽ
	no state.first
	// 最終的にすべてのStateがStateManagerに追加される
	all s: State {
		s in state.last
	}
	// すべての時刻でcurrent_stateはstateの中にある
	all t: Time {
		current_state.t in state.t
	}
}

sig State {}

run {}
