
enum Person {P0, P1, P2, P3, P4}


enum Bool {T, F}


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

pred satisfy(cs: Constrain, p0_0, p0_1, p1_0, p1_1, p2_0, p2_1, p3_0, p3_1, p4_0, p4_1: Bool){
  let
		b0 = (P0 -> p0_0) + (P1 -> p1_0) + (P2 -> p2_0) + (P3 -> p3_0) + (P4 -> p4_0),
  	b1 = (P0 -> p0_1) + (P1 -> p1_1) + (P2 -> p2_1) + (P3 -> p3_1) + (P4 -> p4_1)
  {
		// b0: Person -> Bool // 正直
		// b1: Person -> Bool // 小心
		// 嘘つきの人数を指定
		#{b0.F} = 3
		// すべての嘘つき発言について、発言者が正直なら充足される
		all c: cs & is_liar{
			(c.by.b0 = T) => (c.who.b0 = F)
		}
		// すべての小心者発言について、発言者が正直なら充足される
		all c: cs & is_coward{
			(c.by.b0 = T) => (c.who.b1 = T)
		}
		// すべてのnot小心な嘘つきについて
		all p: b0.F & b1.F {
			// 全て正直ではない:
			(not
			all c: (is_coward <: by).p {
				c.who.b1 = T
			})or(
			not all c: (is_liar <: by).p {
				c.who.b0 = F
			})
			
		}
		
  }
}


run {
  let answers = {
    p0_0, p0_1, p1_0, p1_1, p2_0, p2_1, p3_0, p3_1, p4_0, p4_1: Bool |
    satisfy[Constrain, p0_0, p0_1, p1_0, p1_1, p2_0, p2_1, p3_0, p3_1, p4_0, p4_1]}
    {

    one answers

    all x: Constrain {
      not one {
        p0_0, p0_1, p1_0, p1_1, p2_0, p2_1, p3_0, p3_1, p4_0, p4_1: Bool |
        satisfy[Constrain - x, p0_0, p0_1, p1_0, p1_1, p2_0, p2_1, p3_0, p3_1, p4_0, p4_1]
      }
    }
  }
}
