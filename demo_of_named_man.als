open named_man_ja [Man]
open named_woman_ja [Woman]

abstract sig Person {
  love: Person
}

abstract sig Man extends Person {
}

abstract sig Woman extends Person {
}


run {
//  all p: Person | some p.~love
} for exactly 3 Man, exactly 5 Woman
