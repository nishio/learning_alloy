// 
open named_man_ja [Man]
open named_woman_ja [Woman]
open util/ordering[Event]

abstract sig Person {
  state: State -> Time
}
abstract sig Man extends Person {}
abstract sig Woman extends Person {}

abstract sig State {}
one sig Married extends State {}
one sig NotMarried extends State {}

abstract sig Event {
	who: set Person,
	what: EventType
}
enum EventType {Marriage, Divorce, Nothing}
/*
sig Marriage extends Event{}
sig Divorce extends Event{}
sig Nothing extends Event{}
*/
fact {
	all e: Event {
		// 全ての人は各時点で1つの状態を持つ
		all p: Person | one p.state.e
	}
	all e: Event {
		// 結婚と離婚は2人の人が関係するイベントである
		e.what in Marriage + Divorce => #{e.who} = 2
	}
	no what.Nothing.who
	first.what = Nothing
	Person.state.first = NotMarried
	all e: {e: Event | e.what = Marriage} {
		e.who.state.e = Married
		e.who.state.(e.prev) = NotMarried
	}
	all e: {e: Event | e.what = Divorce} {
		e.who.state.e = NotMarried
		e.who.state.(e.prev) = Married
	}
	all e: Event - first {
		all p: Person {
			p not in e.who => p.state.e = p.state.(e.prev)
		}
	}
}

run {
//	#{e: Event | e.what = Marriage} = 2
	state.(what.Marriage) = Person
} for 5 Event, exactly 2 Man, exactly 1 Woman
