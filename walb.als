// walb
open util/ordering[OrderedPack]
open util/ordering[Request]

// Requestの分類
abstract sig Request{
	addr: Int,
	size: Int,
	belong: lone Pack
}{
	addr > 0
	size > 0
}

sig WriteReq extends Request{}{
	one belong
	belong in WritePack
}

sig ReadReq extends Request{}{
	one belong
	belong in ReadPack
}

sig Flush extends Request{}{
	no belong
}

// Packの分類
abstract sig Pack {}

abstract sig OrderedPack extends Pack{}

sig WritePack extends OrderedPack {
	log: one LogPack,
	data: one DataPack
	
}

sig ReadPack extends OrderedPack {}

sig LogPack extends Pack {}

sig DataPack extends Pack {}

fact {
	all p: LogPack | one p.~log
	all p: DataPack | one p.~data
}

pred overlap(disj ri, rj: Request){
	//Given i, j where i != j, 
	// not (addr(req_i) + size(req_i) <= addr(req_j) or 
	// addr(reg_j) + size(req_j) <= addr(req_i) is true
	not(
		addr[ri] + size[ri] <= addr[rj] or
		addr[rj] + size[rj] <= addr[ri])
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

run {
	some disj pi, pj : Pack | overlap[pi, pj]
}
