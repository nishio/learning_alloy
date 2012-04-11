// walb
open util/ordering[OrderedPack]
open util/ordering[Request]

// Requestの分類
abstract sig Request{}

sig WriteReq extends Request{
	belong: one WritePack
}

sig ReadReq extends Request{
	belong: one ReadPack
}

sig Flush extends Request{}

// Packの分類
abstract sig Pack {}

abstract sig OrderedPack {}

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

pred overlap(disj r1, r2: Request){}

pred overlap(disj p1, p2: Pack){}

run {}
