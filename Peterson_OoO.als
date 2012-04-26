open util/ordering[Time]

abstract sig Command {}

abstract sig Load extends Command{}
abstract sig Store extends Command{}
sig Movl extends Store{
	value: Int,
	target: (0 + 1) -> Time	
}
sig CmplJe extends Load{
	value: Int,
	target: (0 + 1) -> Time,
	jump_to: Int
}

one sig CriticalSection extends Store{}

fun movl(_value: Int, _target: (0 + 1) -> Time): Movl{
	{m: Movl | m.value = _value and m.target = _target}
}
fun cmpl_je(_value: Int, _target: (0 + 1) -> Time,
		_jump_to: Int): CmplJe{

	{m: CmplJe | 
		m.value = _value and
		m.target = _target and
		m.jump_to = _jump_to
	}
}

sig Time{
	pc: lone Int
}

fact{
	no last.pc
}

sig R{
	// その時刻にまだ実行されていないコマンドの列
	code: (0 + 1) -> Int -> Command -> Time,
	// memory
	turn: (0 + 1) -> Time,
	flag: (0 + 1) -> (0 + 1) -> Time
	//
}{
	all t: Time {
		one turn.t
		one flag[0].t
		one flag[1].t
		(turn + flag[0] + flag[1]).t in (0 + 1) 
		no flag[Int - 0 - 1].t
	}

	let t = first {
		// 最初はメモリはみんな0
		turn.t = 0
		flag[0].t = 0
		flag[1].t = 0
 	}

	code.first = (0 -> (
		(0 -> movl[1, flag[0]]) + 
		(1 -> movl[1, turn]) + 
		(2 -> cmpl_je[0, flag[1], 4]) + 
		(3 -> cmpl_je[1, turn, 2]) +
		(4 -> CriticalSection) + 
		(5 -> movl[0, flag[0]]) +

		(6 -> movl[1, flag[0]]) + 
		(7 -> movl[1, turn]) + 
		(8 -> cmpl_je[0, flag[1], 10]) + 
		(9 -> cmpl_je[1, turn, 8]) +
		(10 -> CriticalSection) + 
		(11 -> movl[0, flag[0]])
	) + (1 -> (
		(0 -> movl[1, flag[1]]) + 
		(1 -> movl[1, turn]) + 
		(2 -> cmpl_je[0, flag[0], 4]) + 
		(3 -> cmpl_je[1, turn, 2]) +
		(4 -> CriticalSection) + 
		(5 -> movl[0, flag[1]])
	)))
}
/*
LBB4_1:
        movl    $1, _flag0(%rip)
        movl    $1, _turn(%rip)
LBB4_2:
        cmpl    $0, _flag1(%rip)
        je      LBB4_4
        cmpl    $1, _turn(%rip)
        je      LBB4_2
LBB4_4:
        incl    _counter(%rip)
        movl    $0, _flag0(%rip)
*/


pred InOrder {
	// 選ばれた命令より前に未実行の命令はない
	// 古き良き時代のインオーダー実行
}
pred X86 {
	
}
pred sfence(i: Int){
	// まだWが残っている状態で次のWを読んではいけない
}
pred lfence(i: Int){
	// まだRが残っている状態でRやWを読んではいけない
}
pred mfence(i: Int){
	// RやWが残っている状態でRやWを読んではいけない
}
pred step {
	// 各時刻に守られているべき制約
	
}
fact {
	all t: Time - first {
		step[t]
	}
}

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

check MutualExclusion {
	no t: Time {
		PC.proc[0].t = 3
		PC.proc[1].t = 3
	}
} for 15 Time


run {
} for 5 Int
