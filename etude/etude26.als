// 誤信念課題
open util/ordering[Time]
sig Time {}
abstract sig Belief {}

// アイスクリーム屋はどこにいる？
abstract sig InWhere extends Belief {}
one sig InPark extends InWhere {}
one sig InStation extends InWhere {}

abstract sig Person {
	belief: Belief -> Time,
	others_belief: Person -> Belief -> Time
}
one sig Alice extends Person {}
one sig Bob extends Person {}

// 最初はみんな何も信念がない
pred init(t: Time){
	all p: Person {
		no p.belief.t
		no p.others_belief.t
	}
}

pred step(now, prev: Time, b: InWhere, targets: Person){
	all p: Person {
		(p in targets) => {
			p.belief.now = p.belief.prev - InWhere + b
			p.others_belief.now = (
				p.others_belief.prev ++ 
				((targets - p) -> b)
			)
		}else{
			p.belief.now = p.belief.prev
			p.others_belief.now = p.others_belief.prev
		}
	}
}
run {
	some times: seq Time{
		#times = 4
		all i: times.butlast.inds {
			times[i].next = times[plus[i, 1]]
		}
		init[times[0]]
		step[times[1], times[0], InPark, Alice + Bob]
		step[times[2], times[1], InStation, Alice]
		step[times[3], times[2], InStation, Bob]
	}
} for 4 Time
