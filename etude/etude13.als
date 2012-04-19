// A.1.8
sig Node{
	edge: set Node 
}
pred acyclic {
	edge in ~edge
	all e: edge {
		e not in ^(edge - e - ~e)
	}
}

run acyclic for 4
