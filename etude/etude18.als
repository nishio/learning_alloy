one sig StateManager {
	state: set State
}

sig State {}

//fact {
//	all s: State | s in StateManager.state
//}

run {} for exactly 3 State
