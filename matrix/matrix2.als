open util/ordering[Col] as cols
open util/ordering[Row] as rows

abstract sig Region {}
sig Col extends Region {
  cell: Row -> Cell
}
sig Row extends Region {}
enum Cell { Black, White }

fact {
  all c: Col, r: Row | one cell [c, r]
}

run{
	#Col = 10
	#Row = 10
} for 10 but 5 int
