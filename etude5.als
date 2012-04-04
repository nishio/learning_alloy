open named_man_ja [Man]
open named_woman_ja [Woman]
open util/ordering[Event]

abstract sig Person {
}

abstract sig Man extends Person {
	wife: lone Woman
}

abstract sig Woman extends Person {
	private hasband: lone Man
}

abstract sig Event {
 m: Man,
 f: Woman
}

sig Marriage extends Event{
}

sig Divorce extends Event{
 of: Marriage
}

fact {
  all m: Marriage | lone m.~of
  all d: Divorce | d.of.m = d.m && d.of.f = d.f
  all x: Woman | x.~f.f = x
  all x: Man | x.~m.m = x
  all x: Person | 
}

run {
  #Man = 2
  #Woman = 2
} for 5
