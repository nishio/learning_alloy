enum Person {A, B, C, D, E}
enum Bool {T, F}

// 制約
abstract sig Constrain{}
// 「Xが『Yは嘘つきだ』と言った」という制約
sig is_liar extends Constrain {
	by: one Person,
	who: one Person
}{
	by not in who
}

fact {
	// 違う人は違うことを言う
	all disj p1, p2: Person {
		by.p1 != by.p2
	}
	// 一人の人は3人以上を嘘つき呼ばわりしない
	all p: Person {
		#{by.p} < 3
	}
}


// 与えられたx, y, zの真偽値の対が制約を満たすかどうか返す
// 引数を変えて試すため、述語にくくり出されている必要がある
pred satisfy(cs: Constrain, a, b, c, d, e: Bool){
	let p2b = (A -> a) + (B -> b) + (C -> c) +
		(D -> d) + (E -> e)
		{
		// 嘘つきの人数を指定
		#{p2b.F} = 3
		// すべての制約について、発言者が正直なら充足される
		// 今は「whoは嘘つき」しかない
		all c: cs{
			(c.by.p2b = T) => (c.who.p2b = F)
		}
	}
}



run {
	let answers = {
		a, b, c, d, e: Bool | 
		satisfy[Constrain, a, b, c, d, e]}
		{

		// 解は一つ
		one answers

		// どの制約を取り除いても解は一つではなくなる
		all x: Constrain {
			not one {
				a, b, c, d, e: Bool | 
				satisfy[Constrain - x, a, b, c, d, e]
			}
		}
	}
} for 10

