open util/ordering[Time]

abstract sig AbsPerson {
	//観察者も含めた人物
	belief: Person -> Person -> Place -> Time,
}
sig Observer extends AbsPerson {}

//登場人物
abstract sig Person extends AbsPerson{
	// 最終的にどこへ行ったか
	real_place: Place -> Time
}{
	all t: Time | lone real_place.t
}

one sig X extends Person{}
one sig A extends Person{}
one sig B extends Person{}
one sig C extends Person{}
//one sig D extends Person{}
//one sig E extends Person{}
//one sig F extends Person{}

sig Time {
	// 各時刻に誰かが誰かに自分がどこに行くかを伝える
	who: some Person,
	targets: some AbsPerson,
	where: Place
}{
	// 話し手は聞き手に含まれる
	who in targets
	// 聞き手が話し手と同一ではいけない
	some targets - Observer - who
}
// 誰かと会う、どこかへ行く

sig Place {}

fact {
	// 同じ人が複数箇所に存在すると信じることはない
	all p1, p2, p3: Person, t: Time{
		lone (p1.belief)[p2, p3].t
	}
}

fun where_is_x(self: Person): Place {
	let where = self.(self.belief).last {
		X.where
	}
}
// Xを殺すことが可能だったのは？
fun can_kill(self: AbsPerson): Person{
	let where = self.(self.belief).last {
		X.where.~where - X
	}
}

// whoと同じ場所にいた可能性があるのは？
fun same_place(self: AbsPerson, who: Person): Person{
	let where = self.(self.belief).last {
		who.where.~where + {p: Person | no p.where} - who
	}
}

pred init(t: Time){
	all p: AbsPerson {
		no p.belief.t
	}
	all p: Person {
		no p.real_place.t
	}
}
pred step(t', t: Time){
	all p: Person {
		(p in t.targets) => {
			// 聞いた人の信念が上書きされる
			p.belief[p].t = p.belief[p].t' ++ (t.who -> t.where)
			// 第二次誤信念は今回は扱わない
			no p.belief[Person - p].t
		}else{
			p.belief.t = p.belief.t'
		}
		(p in t.who) => {
			// 自分が言ったところに行く(嘘はつかない)
			p.real_place.t = t.where
		}else{
			p.real_place.t = p.real_place.t'
		}
	}
}
pred final(t', t: Time){
	all p: Person {
		let go = real_place.t',
				place = p.go, 
				meets = go.place {
			// 最終的にどこかには行った
			one place
			p.real_place.last = place
			// 最終的に同じ場所に行った人は信念が更新される
			p.belief[p].t = p.belief[p].t' ++ (meets -> place)
		}
	}
}
run {
	init[first]
	all t: Time - last - first{
		step[t.prev, t]
	}
	final[last.prev, last]
	// AはBが犯人だと、BはAが犯人だと考えている
	same_place[A, X] = B
	same_place[B, X] = A
	// 二人ともアリバイはないが自分が犯人ではない
	no same_place[A, A]
	no same_place[B, B]
	// Cは自分が犯人だと知っている
	same_place[C, X] = C
} for 7 Time, 3 Place, 1 Observer
