open util/ordering[Time]
/*
sig RealStorage {
	state: State -> Time
}

sig VirtualStorage {
	state: State
}*/


one sig Storage{
	value: Int -> Time
}

sig Time{}

fact {
	all t: Time | lone t.~write
}

sig Process {
	read: Time,
	write: Time
}{
	read in write.prevs
}
fact {
	Storage.value.first = 0
	all t: Time - first{
		let t' = t.prev, p = t.~write {
			some p => {
				Storage.value.t = plus[1, Storage.value.(p.read)]
			}else{
				Storage.value.t = Storage.value.t'
			}
		}
	}
}


check {
	Storage.value.last = #Process
}
