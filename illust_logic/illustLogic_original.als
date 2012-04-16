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

-- about rows
pred blackHeadInRow (c: Col, r: Row) {
  c in first or cell[c.prev, r] in White
  cell[c, r] in Black
}

fun headsInRow (r: Row): set Col {
  { c: Col | blackHeadInRow[c, r] }
}

fact noOtherHeadsInRow {
  no c: Col, r: Row | c not in headsInRow[r] and blackHeadInRow[c, r]
}

pred headsSeqInRow (r: Row, s: seq Col) {
  s.elems = headsInRow[r]
  all i: s.butlast.inds | lt [s[i], s[plus[i, 1]]]
}

fun Int2Row (i: Int): Row {
  {r: Row | #(r.prevs) = i}
}

fun Row2Int (r: Row): Int {
  #(r.prevs)
}

pred rowHint (j: Int, sizes: seq Int) {
  let r = Int2Row[j] | some cs: seq Col {
    #sizes = #cs
    headsSeqInRow [r, cs]
    all i: sizes.inds | 
      let start = cs [i], end = Int2Col [plus [Col2Int [start], minus[sizes [i], 1] ]] {
       some end
       all c: start.*cols/next - end.^cols/next | cell [c, r] in Black
       no end.next or cell [end.next, r] in White
     }
  }
}

-- about cols
pred blackHeadInCol (c: Col, r: Row) {
  r in first or cell[c, r.prev] in White
  cell[c, r] in Black
}

fun headsInCol (c: Col): set Row {
  { r: Row | blackHeadInCol[c, r] }
}

fact noOtherHeadsInCol {
  no c: Col, r: Row | r not in headsInCol[c] and blackHeadInCol[c, r]
}

pred headsSeqInCol (c: Col, s: seq Row) {
  s.elems = headsInCol[c]
  all i: s.butlast.inds | lt [s[i], s[plus[i, 1]]]
}

fun Int2Col (i: Int): Col {
  {c: Col | #(c.prevs) = i}
}

fun Col2Int (c: Col): Int {
  #(c.prevs)
}

pred colHint (j: Int, sizes: seq Int) {
  let c = Int2Col[j] | some rs: seq Row {
    #sizes = #rs
    headsSeqInCol [c, rs]
    all i: sizes.inds | 
      let start = rs [i], end = Int2Row [plus [Row2Int [start], minus[sizes [i], 1] ]] {
       some end
       all r: start.*rows/next - end.^rows/next | cell [c, r] in Black
       no end.next or cell [c, end.next] in White
     }
  }
}

-- riddle from http://homepage1.nifty.com/sabo10/rulelog/illust.html
solve: run {
  rowHint [0, 0 -> 3]
  rowHint [1, 0 -> 2 + 1 -> 2]
  rowHint [2, 0 -> 1 + 1 -> 1 + 2 -> 1]
  rowHint [3, 0 -> 3 + 1 -> 3]
  rowHint [4, 0 -> 5]
  rowHint [5, 0 -> 7]
  rowHint [6, 0 -> 7]
  rowHint [7, 0 -> 7]
  rowHint [8, 0 -> 7]
  rowHint [9, 0 -> 5]

  colHint [0, 0 -> 4]
  colHint [1, 0 -> 6]
  colHint [2, 0 -> 7]
  colHint [3, 0 -> 9]
  colHint [4, 0 -> 2 + 1 -> 7]
  colHint [5, 0 -> 1 + 1 -> 6]
  colHint [6, 0 -> 2 + 1 -> 4]
  colHint [7, 0 -> 3]
  colHint [8, 0 -> 1]
  colHint [9, 0 -> 2]
} for 10 but 5 Int
