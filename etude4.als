module etude4
open util/ordering[Event]

abstract sig Event {
  nextEvent: lone Event
}

fact {
 all e: Event |
   nextEvent[e] = next[e]
}


sig Start extends Event{
}

sig Stop extends Event{
}

fact {
 all e: Start | let x = #(Start & e.^next) - #(Stop & e.^next) {x = 0} 
 all e: Stop | let x = #(Start & e.^next) - #(Stop & e.^next) {x = 1} 
//  all e: Event | { let x = minus[#(Start & e.^next), #(Stop & e.^next)] | {x = 0 || x = 1} }
//  all e: Event | let x = #(Start & e.^next)| {x = 0 || x = 1}
//  #Start - #Stop = 1
}

run {
} for 5
