open util/ordering[Time]
sig Time {}

one sig Memory {
	turn: Int -> Time,
	flag: Int -> Int -> Time
}{
	all t: Time {
		one flag[0].t
		one flag[1].t
		no flag[Int - 0 - 1].t
	}
}

one sig PC {
	proc: Int -> Int -> Time,
	current_pid: Int -> Time
}{
	all t: Time {
		one proc[0].t
		one proc[1].t
		no proc[Int - 0 - 1].t
	}
}


fact {
	// 最初はメモリはみんな0
	let t = first {
		Memory.turn.t = 0
		Memory.flag[0].t = 0
		Memory.flag[1].t = 0
		// 最初はプログラムカウンタは0
		PC.proc[0].t = 0
		PC.proc[1].t = 0
 	}
}

pred store(t: Time, target: univ -> Time, value: univ){
	one value
	target.t = value
}

pred must_wait(t: Time, pid: Int){
	let other = (0 + 1) - pid {
		Memory.flag[other].t = 1 // otherがwaitしている
		Memory.turn.t = other // otherが優先権を持っている
	}
}

pred no_change(t: Time, changable: univ -> Time){
	changable.t = changable.(t.prev)
}

pred step(t: Time) {
	// 各時刻でどちらかのプロセスが1命令実行する
	some pid: (0 + 1) {
		PC.current_pid.t = pid
		let pc = PC.proc[pid].(t.prev),
				nextpc = PC.proc[pid].t,
				other = (0 + 1) - pid
		{

			(pc = 0) => {
				// flag[0] = 1
				store[t, Memory.flag[pid], 1]
				nextpc = plus[pc, 1]
				no_change[t, Memory.turn]
			}
			(pc = 1) => {
				// turn = 1
				store[t, Memory.turn, other]
				nextpc = plus[pc, 1]
				no_change[t, Memory.flag[pid]]
			}
			(pc = 2) => {
				// while( flag[1] && turn == 1 );
				must_wait[t, pid] => {
					nextpc = pc
				}else{
					nextpc = plus[pc, 1]
				}
				no_change[t, Memory.turn]
				no_change[t, Memory.flag[pid]]
			}
			(pc = 3) => {
				// flag[0] = 0
				store[t, Memory.flag[pid], 0]
				nextpc = 0
				no_change[t, Memory.turn]
			}

			// no change
			no_change[t, PC.proc[other]]
			no_change[t, Memory.flag[other]]
		}
	}
}

check MutualExclusion {
	no t: Time {
		PC.proc[0].t = 3
		PC.proc[1].t = 3
	}
} for 15 Time

check BoundedWaiting_Bad {
	no t: Time, pid: Int {
		PC.proc[pid].t = 2
		PC.proc[pid].(t.next) = 2
		PC.proc[pid].(t.next.next) = 2
		PC.proc[pid].(t.next.next.next) = 2
		PC.proc[pid].(t.next.next.next.next) = 2
	}
} for 15 Time

check BoundedWaiting {
	no t, t': Time, pid: Int {
		let range = Time - t.prevs - t'.nexts {
			// あるプロセスがずっと2(ロック待ち)で
			all t'': range | PC.proc[pid].t'' = 2
			// その間、もう片方のプロセスが2回以上3(クリティカルセクション)を実行
			#{t'': range | 
				PC.proc[PC.current_pid.t''].t'' = 3
			} >= 2
		}
	}
} for 15 Time

fact {
	all t: Time - first {
		step[t]
	}
}
run {
} for exactly 20 Time
