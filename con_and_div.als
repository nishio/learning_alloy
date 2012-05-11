// 一貫性主義者と多様性主義者のパズル
// 一貫性主義者はすべて嘘をつくか、すべて正直に話すかのどちらか
// 多様性主義者はすべて嘘をつくこともすべて正直に話すこともない

abstract sig Person {
  con: set Person,
  div: set Person,
  same: set Person
}

one sig P0 extends Person {}
one sig P1 extends Person {}
one sig P2 extends Person {}
one sig P3 extends Person {}
one sig P4 extends Person {}

fact{
  all p, q: Person{
    
    (q in p.con) <=> (
      some c: Con{
        c.by = p
        c.who = q
      }
    )

    (q in p.div) <=> (
      some c: Div{
        c.by = p
        c.who = q
      }
    )

    (q in p.same) <=> (
      some c: Same{
        c.by = p
        c.who = q
      }
    )
  }
}


enum Bool {T, F}


abstract sig Constrain{
	by: one Person,
	who: one Person
}{
	by not in who
}

sig Con extends Constrain {}
sig Div extends Constrain {}
sig Same extends Constrain {}

pred is_correct(c: Constrain, bb: Person -> Bool){
	(c in Con) => (c.who.bb = T)
	(c in Div) => (c.who.bb = F)
	(c in Same) => (c.who.bb = c.by.bb)
}

pred satisfy(cs: Constrain, p0, p1, p2, p3, p4: Bool){
  let bb = (P0 -> p0) + (P1 -> p1) + (P2 -> p2) + (P3 -> p3) + (P4 -> p4)
  {
		// bb: Person -> Bool 一貫性主義者かどうか
		#{bb.T} = 3
		all p: bb.T { //すべての一貫性主義者について
			// 全て正しいか全て嘘かのどちらか
			(all c: by.p{is_correct[c, bb]})
			or
			(all c: by.p{not is_correct[c, bb]})
		}
		all p: bb.F { //すべての多様性主義者について
			// 全て正しくはなく、またすべて嘘でもない
			not (all c: by.p{is_correct[c, bb]})
			not (all c: by.p{not is_correct[c, bb]})
		}
  }
}

run {
	// 制約が1個以上ある
  //some Constrain
	// みんな2回以上しゃべる
	all p: Person {#{by.p} >= 2}
	// 相異なる制約は異なる
	all disj c1, c2: Same {
		not(c1.by = c2.by and c1.who = c2.who)
	}
	all disj c1, c2: Con {
		not(c1.by = c2.by and c1.who = c2.who)
	}
	all disj c1, c2: Div {
		not(c1.by = c2.by and c1.who = c2.who)
	}
  let answers = {
    p0, p1, p2, p3, p4: Bool |
    satisfy[Constrain, p0, p1, p2, p3, p4]}
  {

    one answers
    all x: Constrain {
      not one {
        p0, p1, p2, p3, p4: Bool |
        satisfy[Constrain - x, p0, p1, p2, p3, p4]
      }
    }
  }
} for 40 Constrain

