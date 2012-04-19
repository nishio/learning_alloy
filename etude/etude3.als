open named_man_ja [Man]
open named_woman_ja [Woman]
open util/ordering[Person]

abstract sig Person {
 mother: lone Woman,
 father: lone Man
}

abstract sig Man extends Person {
	wife: lone Woman
}

abstract sig Woman extends Person {
	private hasband: lone Man
}

fact {
	all x: Man | x in x.wife.hasband
	all x: Woman | x in x.hasband.wife
    all x: Man | x not in x.^father
    all x: Woman | x not in x.^mother
}

fact {
  let ancestor = ^(mother + father) | no (wife + hasband) & ancestor
}

fact {
  let parent = (mother + father) | 
    let r = parent + ~parent |
      no (wife + hasband) & (r + r.r + r.r.r)
}

fact {
 all x: Person | x.mother in x.^~next 
 all x: Person | x.father in x.^~next
}

run {
    #Person.father > 2
   #Person.mother > 2
} for 10
