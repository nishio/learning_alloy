
enum Person {A, B, C, D, E}

enum Bool {T, F}
enum BoolBool {TT, TF, FT, FF}

abstract sig Constrain{
	by: one Person,
	who: one Person
}{
	by not in who
}
fact {
	all disj: x, y: Constrain {
		not {
			x.by = y.by
			x.who = y.who
			(x in is_liar) <=> (y in is_liar)
		}
	}
}
sig is_liar extends Constrain {}
sig is_coward extends Constrain {}

pred satisfy(cs: Constrain, a, b, c, d, e: BoolBool){
  let
		bb = (A -> a) + (B -> b) + (C -> c) + (D -> d) + (E -> e),
		b0 = bb.(TT -> T + TF -> T + FT -> F + FF -> F),
  	b1 = bb.(TT -> T + TF -> F + FT -> T + FF -> F)
  {
		// b0: Person -> Bool // 正直T 嘘つきF
		// b1: Person -> Bool // 臆病T 
		// 嘘つきの人数を指定
		#{b0.T} = 3
		// 小心者の人数を指定
		#{b1.T} = 3
		// すべての嘘つき発言について、
		// 発言者が嘘つきでないなら対象は嘘つき
		all c: cs & is_liar{
			(c.by.b0 = F) => (c.who.b0 = T)
		}
		// すべての小心者発言について、
		// 発言者が嘘つきでないなら対象は臆病
		all c: cs & is_coward{
			(c.by.b0 = F) => (c.who.b1 = T)
		}
		// すべての小心な嘘つきについて
		all p: b0.T & b1.T {
			// 一つしか嘘をつかない:
				#{c: by.p | 
					(c in is_liar and c.who.b0 = F) or
					(c in is_coward and c.who.b1 = F)
				} = 1
		}
  }
}


run {
	all p: Person {#(by.p) > 1}
  let answers = {
    a, b, c, d, e: BoolBool |
    satisfy[Constrain, a, b, c, d, e]}
    {

    one answers
  }
} for 5 is_liar, 5 is_coward
