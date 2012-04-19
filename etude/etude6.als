open named_man_ja [Man]
open named_woman_ja [Woman]
//open util/ordering[Event]

abstract sig Person {
  events: set Event,
  states: some State
}

abstract sig Man extends Person {
}

abstract sig Woman extends Person {
}

abstract sig State {
}
sig Married extends State {}
sig NotMarried extends State {}

abstract sig Event {
  state_change : State -> State
}

sig Marriage extends Event{
}

sig Divorce extends Event{
}

fact {
  // すべてのイベントは2人に関係している
  all e: Event | #{e.~events} = 2
  // すべてのイベントは1人の男性(と1人の女性)に関係している
  all e: Event | #{e.~events & Man} = 1

  all p: Person | #(p.states) = #(p.events) + 1
  all s: State | #(s.~states) = 1
  all e: Event | #(e.state_change) = 2
  all e: Event | no e.state_change & iden
}

run {
//  all p: Person | some p.events // すべての人がイベントを持っている
  #Man = 1
  #Woman = 1
  #Event = 2
} for 15
