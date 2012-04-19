// sec 6.1
open util/ordering[Time]
open util/ordering[Process]

sig Time {}

sig Process {
	succ: Process,
	toSend: Process -> Time,
	elected: set Time
}

fact ring {
  all p: Process | Process in p.^succ
}

pred init (t: Time) {
  all p: Process | p.toSend.t = p
}

pred step (t, t': Time, p: Process) {
	let from = p.toSend, to = p.succ.toSend {
		some id: from.t { // exists a id in from.t
			from.t' = from.t - id
			to.t' = to.t + (id - p.succ.prevs)
		}
	}
}

fact DefineElected {
  no elected.first
  all t: Time - first {
		elected.t = {p: Process | p in p.toSend.t - p.toSend.(t.prev)}
	}
}

fact Traces {
	first.init
	all t: Time - last {
		let t' = t.next {
			all p: Process {
				step [t, t', p] or step [t, t', succ.p] or skip[t, t', p]
      }
		}
	}
}

pred skip (t, t': Time, p: Process){
	p.toSend.t = p.toSend.t'
}

pred show {
	some elected
}
run show for 3 Process, 4 Time
// util.orderingのライブラリリファレンスとかあるのかな、ソースを嫁？
// prev, prevs便利
