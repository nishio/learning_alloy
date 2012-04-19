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
  #Man = 3
  #Woman = 5
} for 10
