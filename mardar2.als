open util/ordering[Time]

//登場人物
abstract sig Person {
	belief: Person -> Person -> Place -> Time,
	// 最終的にどこへ行ったか
	real_place: Place -> Time,
	is_killer: lone Person // as bool
}{
	all t: Time | lone real_place.t
}

one sig Me extends Person{} // 読者
one sig PHP extends Person{} // 殺され役
one sig Perl extends Person{}
one sig Python extends Person{}
one sig Ruby extends Person{}
one sig JS extends Person{}

abstract sig Time {}
sig BeforeMardar extends Time {
	// 各時刻に誰かが誰かに自分がどこに行くかを伝える
	who: some Person,
	targets: some Person,
	where: Place
}{
	// 話し手は聞き手に含まれる
	who in targets
	// 聞き手が話し手と同一ではいけない
	some targets - who
}
one sig Mardar extends Time {}

sig Place {}

fact {
	// 同じ人が複数箇所に存在すると信じることはない
	all p1, p2, p3: Person, t: Time{
		lone (p1.belief)[p2, p3].t
	}
}

pred init(t: Time){
	all p: Person {
		no p.belief.t
	}
	all p: Person {
		no p.real_place.t
	}
}

pred no_change(t: Time, changable: univ -> Time){
	changable.t = changable.(t.prev)
}

pred step(t', t: Time){
	all p: Person {
		(p in t.targets) => {
			// 聞いた人pの信念が上書きされる
			// 一緒に聞いていた人(自分を含む)の信念が上書きされる
			all p2: Person {
				(p2 in t.targets) => {
					p.belief[p2].t = p.belief[p2].t' ++ (t.who -> t.where)
				}else{
					// それ以外は変化しない
					p.belief[p2].t = p.belief[p2].t'
				}
			}
		}else{
			// 聞き手以外は信念が変化しない
			p.belief.t = p.belief.t'
		}
		(p in t.who) => {
			// 犯人以外は自分が言ったところに行く(嘘はつかない)
			(no p.is_killer) => p.real_place.t = t.where
		}else{
			p.real_place.t = p.real_place.t'
		}
	}
}

pred on_mardar(t', t: Time){
	all p: Person {
		let go = real_place.t',
				place = p.go, 
				meets = go.place {
			// 全員どこかには行った
			one place
			p.real_place.t = place // 犯行時刻にそこにいた
			// 犯行時刻に同じ場所に行った人は信念が更新される
			p.belief[p].t = p.belief[p].t' ++ (meets -> place)
		}
	}
	// 犯人と殺され役だけが犯行時刻に同じ場所にいた
	PHP.real_place.t.~(real_place.t) = PHP + (is_killer.univ)
}

fact {
	BeforeMardar = Mardar.prevs
	init[first]
	all t: BeforeMardar - first{
		step[t.prev, t]
	}
	on_mardar[Mardar.prev, Mardar]
}

// whoと同じ場所にいた可能性があるのは？
fun same_place(self: Person, who: Person): Person{
	let where = (self.belief)[self].last {
		who.where.~where + {p: Person | no p.where} - who
	}
}


run {
	one is_killer // 犯人は一人だけ
	// Ruby, Python, 読者はPHPがどこに行くつもりか聞いた
	all p: Ruby + Python + Me {
		some t: Time {
			PHP in t.who and p in t.targets
		}
	}
	// Ruby, Python, PHP, 読者は犯人ではない
	no (Ruby + Python + Me + PHP).is_killer
	// 犯人は自分以外はみな自分が犯人だと考えないと考えている
	let killer = is_killer.univ {
		all other: Person - killer - PHP{
			let where = (killer.belief)[other].last {
				killer not in PHP.where.~where
			}
		}
	}
	// 読者は当初PythonかRubyが犯人だと考えている
	same_place[Me, PHP] = Python + Ruby
	// RubyはPythonが犯人だと、PythonはRubyが犯人だと考えている
	same_place[Ruby, PHP] = Python
	same_place[Python, PHP] = Ruby
	// 読者がPythonとRubyの話を聞いた後、正しく犯人を当てられる
	// 3人分の意見を聞いている架空の人の信念を考える
	some belief: Person -> Place -> Time {
		no belief.first
		all t: BeforeMardar - first{
			let t' = t.prev{
				(some (Me + Python + Ruby) & t.targets) => {
					// 三人の誰かが聞いていれば信念が上書きされる
					belief.t = belief.t' ++ (t.who -> t.where)
				}else{
					// 信念が変化しない
					belief.t = belief.t'
				}
			}
		}
		// バグ: ここに最終時刻での信念の更新に関する制約を書く必要があった
		// 3人分の意見をまとめた結果、犯人を正しく推測できる
		let who = PHP, where = belief.last {
			(who.where.~where + {p: Person | no p.where} - who)
			= is_killer.univ
		}
	}
} for 6 Time, 4 Place
