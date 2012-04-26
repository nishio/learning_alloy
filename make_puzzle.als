enum Person {X, Y, Z}
enum Bool {T, F}

// 制約
abstract sig Constrain{}
// 「Xが『Yは嘘つきだ』と言った」という制約
sig is_liar extends Constrain {
	by: one Person,
	who: some Person
}

// 与えられたx, y, zの真偽値の対が制約を満たすかどうか返す
// 引数を変えて試すため、述語にくくり出されている必要がある
pred satisfy(cs: Constrain, x, y, z: Bool){
	let p2b = (X -> x) + (Y -> y) + (Z -> z) {
		// only one liar
		one p2b.F
		// すべての制約について、発言者が正直なら充足される
		// 今は「whoは嘘つき」しかない
		all c: cs{
			(c.by.p2b = T) => (c.who.p2b = F)
		}
	}
}

run {
	let answers = {
		x, y, z: Bool | 
		satisfy[Constrain, x, y, z]}{

		one answers
	}
}

fact {
	all c: Constrain {
		c.by not in c.who
		one c.who
	}
}
