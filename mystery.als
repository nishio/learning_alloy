open util/ordering[Time]
enum Person {A, B, C}
sig Place {}
one sig Nowhere extends Place {}
sig Time {
   visit: Person -> Place
}
fact {
   all t: Time, p: Person {
      one t.visit[p] // 人は一度に一箇所にしかいない
   }
}

enum Bool {T, F}
enum BoolBool {TT, TF, FT, FF}

abstract sig Constrain{
   by: one Person,
   who: one Person
}


sig is_honest extends Constrain {}
sig is_visit extends Constrain {
   when: Time,
   where: Place
}

pred satisfy(cs: Constrain, a, b, c: BoolBool){
   let
      bb = (A -> a) + (B -> b) + (C -> c),
      b0 = bb.(TT -> T + TF -> T + FT -> F + FF -> F),
      b1 = bb.(TT -> T + TF -> F + FT -> T + FF -> F)
   {
      // b0: Person -> Bool // 正直T 嘘をつくかもしれない人
      // b1: Person -> Bool // 犯人T
      // 正直者の人数は1人
      //#{b0.T} = 1
      // 犯人は1人
      #{b1.T} = 1

      // すべての正直発言について、
      // 発言者が正直なら対象も正直
      all c: cs & is_honest{
	 (c.by.b0 = T) => (c.who.b0 = T)
      }
      // すべての目撃情報について
      // 発言者が正直なら
      all c: cs & is_visit{
	 (c.by.b0 = T) => {
	    let t = c.when {
	       t.visit[c.who] = c.where // その時刻にそこにいる
	    }
	 }
      }
   }
}

fact {
   // 人の移動に関する制約
   all t: Time - first, p: Person {
      t.visit[p] = t.prev.visit[p] // 同じ位置にとどまる
      or t.visit[p] = Nowhere or t.prev.visit[p] = Nowhere
   }
}

run {
   let answers = {
      a, b, c: BoolBool |
    	 satisfy[Constrain, a, b, c]}
   {
//	some answers
      one answers
/*
      all x: Constrain {
	 not one {
	    a, b, c: BoolBool |
	       satisfy[Constrain - x, a, b, c]
	 }
      }
*/
   }
} for 3 Place, 3 Time, 20 Constrain
