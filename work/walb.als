// walb
open util/ordering[OrderedPack] as pack
open util/ordering[Request] as req
open util/ordering[Time] as time

enum Bool {True, False}

sig Device {
	real: Bool -> Time,
	virtual: Bool -> Time
}

// Requestの分類
abstract sig Request{
	target: Device,
	belong: lone Pack,
	began: Bool -> Time,
	ended: Bool -> Time
}

sig WriteReq extends Request{}{
	one belong
	belong in WritePack
}

sig ReadReq extends Request{}{
	one belong
	belong in ReadPack
}
/*
sig Flush extends Request{}{
	no belong
}
*/

// Packの分類
abstract sig Pack {
	state: State -> Time
}

abstract sig OrderedPack extends Pack{}

sig WritePack extends OrderedPack {
	log: one LogPack,
	data: one DataPack
}

sig ReadPack extends OrderedPack {}

sig LogPack extends Pack {}

sig DataPack extends Pack {
	action: Action -> Time
}

abstract sig Action {}
one sig Submit extends Action {}

abstract sig State {}
one sig Completed extends State {}
one sig Running extends State {}
 
sig Time {}

fact {
	all p: LogPack | one p.~log
	all p: DataPack | one p.~data
}

pred overlap(disj ri, rj: Request){
	some (ri.target & rj.target)
}

pred overlap(disj pi, pj: Pack){
	// given i, j where i != j, 
	// exists (k, l) such that 
	// overlapped(req_k in pack_i, req_l in pack_j) 
	some rk, rl: Request {
		rk.belong = pi
		rl.belong = pj
		overlap[rk, rl]
	}
}

pred overlap (pi: Pack, rj: Request){
	//given i, j where req_j is not in pack_i, 
	//exists k such that 
	//overlapped(req_k in pack_i, req_j) is true
	rj.belong != pi
	some rk: Request {
		rk.belong = pi
		overlap[rk, rj]
	}
}

fact {
	// 同一Pack内のリクエストはオーバーラップしない
	all p: Pack {
		no disj ri, rj: p.~belong {overlap[ri, rj]}
	}
}

// (c1) datapack_i が submit される前に logpack_j for all j <= i が complete していること． 
fact {
	all t: Time, dp: DataPack, lp: LogPack {
		{
			lte[lp.~log, dp.~data] 
			dp.action.t = Submit
		}
		=> lp.state.t = Completed
	}
}

// (c2) overlap している begin 後 end 前(つまり実行中)の writepack_i と writepack_j (ただし i < j) 
//     について，datapack_i の complete 後に datapack_j が submit されること．
fact {
	all disj pi, pj : WritePack, t: Time {
		{
			overlap[pi, pj]
			lt[pi, pj]
			pi.state.t = Running
			pj.state.t = Running
			pj.data.action.t = Submit
		} => {
			pi.data.state.t = Completed
		}
	}
}

//(c3) write request end 後に overlap する read request が begin した場合， 
//     その write request のデータもしくは依存関係になく begin 後 end 前の 
//     overlap する write (0～複数個)のデータのどれかを必ず読むこと
/*
i < j < k 
writereq_i, ..., readreq_j, ..., (writereq_k)
req_i は req_j と overlap 
req_k は req_j と overlap 
readreq_j は begin 後，end 前 
writereq_i は end 後 
writereq_k は begin 後，end 前 
writereq_i と readreq_j の間には readreq_j と overlap する writereq は存在しない． 

上記の条件を満たす全ての k について writereq_k のどれか 
もしくは writereq_i のデータに readreq_j はアクセスする． 
*/
fact {
	all disj wr, wr2: WriteReq, rr: ReadReq, t: Time {
		{
			lt[wr, rr]
			lt[rr, wr2]
			overlap[wr, rr]
			overlap[rr, wr2]
			rr.began.t = True
			rr.ended.t = False
			wr.ended.t = True
			wr2.began.t = True
			wr2.ended.t = False
			no wr3: WriteReq {
				lt[wr, wr3] and lt[wr3, rr] and overlap[wr3, rr]
			}
		} => {
			
		}
	}
}


run {
//	some disj pi, pj : Pack | overlap[pi, pj]
}
