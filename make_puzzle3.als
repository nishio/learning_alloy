
enum Person {A, B, C, D, E}

enum Bool {T, F}
enum BoolBool {TT, TF, FT, FF}

abstract sig Constrain{}

sig is_liar extends Constrain {
	by: one Person,
	who: one Person
}{
	by not in who
}

sig is_coward extends Constrain {
	by: one Person,
	who: one Person
}{
	by not in who
}

pred satisfy(cs: Constrain, a, b, c, d, e: BoolBool){
  let
		bb = (A -> a) + (B -> b) + (C -> c) + (D -> d) + (E -> e),
		b0 = bb.(TT -> T + TF -> T + FT -> F + FF -> F),
  	b1 = bb.(TT -> T + TF -> F + FT -> T + FF -> F)
  {
		// b0: Person -> Bool // 正直
		// b1: Person -> Bool // 小心
		// 嘘つきの人数を指定
		#{b0.F} = 2
		// 小心者の人数を指定
		#{b1.T} = 2
		// すべての嘘つき発言について、発言者が正直なら充足される
		all c: cs & is_liar{
			(c.by.b0 = T) => (c.who.b0 = F)
		}
		// すべての小心者発言について、発言者が正直なら充足される
		all c: cs & is_coward{
			(c.by.b0 = T) => (c.who.b1 = T)
		}
		// すべての小心な嘘つきについて
		all p: b0.F & b1.T {
			// 一つしか嘘をつかない:
			plus[
				#{c: (is_coward <: by).p | c.who.b1 = F},
				#{c: (is_liar <: by).p | c.who.b0 = T}
			] = 1
		}
  }
}


run {
  let answers = {
    a, b, c, d, e: BoolBool |
    satisfy[Constrain, a, b, c, d, e]}
    {

    one answers

    all x: Constrain {
      not one {
        a, b, c, d, e: BoolBool |
        satisfy[Constrain - x, a, b, c, d, e]
      }
    }

  }
} for 7
