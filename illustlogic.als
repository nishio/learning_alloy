// Illust Logic
abstract sig Cell {
  color: Color,
  hnext: lone Cell,
  vnext: lone Cell
}

enum Color {Black, White}

fun range(start, end : Cell, r: Cell -> Cell): Cell{
  (start + start.^r) & (end.^(~r) + end)
}

pred all_black(cells : Cell, size: Int){
  #cells = size
  all c: cells{
    c.color = Black
  }
}

pred all_white(cells : Cell){
  all c: cells{
    c.color = White
  }
}

fun from(start: Cell, next: Cell -> Cell): Cell{
  start + start.^next
}

one sig Cell_0_0 extends Cell {}
one sig Cell_0_1 extends Cell {}
one sig Cell_0_2 extends Cell {}
one sig Cell_0_3 extends Cell {}
one sig Cell_0_4 extends Cell {}
one sig Cell_0_5 extends Cell {}
one sig Cell_0_6 extends Cell {}
one sig Cell_0_7 extends Cell {}
one sig Cell_0_8 extends Cell {}
one sig Cell_0_9 extends Cell {}
one sig Cell_1_0 extends Cell {}
one sig Cell_1_1 extends Cell {}
one sig Cell_1_2 extends Cell {}
one sig Cell_1_3 extends Cell {}
one sig Cell_1_4 extends Cell {}
one sig Cell_1_5 extends Cell {}
one sig Cell_1_6 extends Cell {}
one sig Cell_1_7 extends Cell {}
one sig Cell_1_8 extends Cell {}
one sig Cell_1_9 extends Cell {}
one sig Cell_2_0 extends Cell {}
one sig Cell_2_1 extends Cell {}
one sig Cell_2_2 extends Cell {}
one sig Cell_2_3 extends Cell {}
one sig Cell_2_4 extends Cell {}
one sig Cell_2_5 extends Cell {}
one sig Cell_2_6 extends Cell {}
one sig Cell_2_7 extends Cell {}
one sig Cell_2_8 extends Cell {}
one sig Cell_2_9 extends Cell {}
one sig Cell_3_0 extends Cell {}
one sig Cell_3_1 extends Cell {}
one sig Cell_3_2 extends Cell {}
one sig Cell_3_3 extends Cell {}
one sig Cell_3_4 extends Cell {}
one sig Cell_3_5 extends Cell {}
one sig Cell_3_6 extends Cell {}
one sig Cell_3_7 extends Cell {}
one sig Cell_3_8 extends Cell {}
one sig Cell_3_9 extends Cell {}
one sig Cell_4_0 extends Cell {}
one sig Cell_4_1 extends Cell {}
one sig Cell_4_2 extends Cell {}
one sig Cell_4_3 extends Cell {}
one sig Cell_4_4 extends Cell {}
one sig Cell_4_5 extends Cell {}
one sig Cell_4_6 extends Cell {}
one sig Cell_4_7 extends Cell {}
one sig Cell_4_8 extends Cell {}
one sig Cell_4_9 extends Cell {}
one sig Cell_5_0 extends Cell {}
one sig Cell_5_1 extends Cell {}
one sig Cell_5_2 extends Cell {}
one sig Cell_5_3 extends Cell {}
one sig Cell_5_4 extends Cell {}
one sig Cell_5_5 extends Cell {}
one sig Cell_5_6 extends Cell {}
one sig Cell_5_7 extends Cell {}
one sig Cell_5_8 extends Cell {}
one sig Cell_5_9 extends Cell {}
one sig Cell_6_0 extends Cell {}
one sig Cell_6_1 extends Cell {}
one sig Cell_6_2 extends Cell {}
one sig Cell_6_3 extends Cell {}
one sig Cell_6_4 extends Cell {}
one sig Cell_6_5 extends Cell {}
one sig Cell_6_6 extends Cell {}
one sig Cell_6_7 extends Cell {}
one sig Cell_6_8 extends Cell {}
one sig Cell_6_9 extends Cell {}
one sig Cell_7_0 extends Cell {}
one sig Cell_7_1 extends Cell {}
one sig Cell_7_2 extends Cell {}
one sig Cell_7_3 extends Cell {}
one sig Cell_7_4 extends Cell {}
one sig Cell_7_5 extends Cell {}
one sig Cell_7_6 extends Cell {}
one sig Cell_7_7 extends Cell {}
one sig Cell_7_8 extends Cell {}
one sig Cell_7_9 extends Cell {}
one sig Cell_8_0 extends Cell {}
one sig Cell_8_1 extends Cell {}
one sig Cell_8_2 extends Cell {}
one sig Cell_8_3 extends Cell {}
one sig Cell_8_4 extends Cell {}
one sig Cell_8_5 extends Cell {}
one sig Cell_8_6 extends Cell {}
one sig Cell_8_7 extends Cell {}
one sig Cell_8_8 extends Cell {}
one sig Cell_8_9 extends Cell {}
one sig Cell_9_0 extends Cell {}
one sig Cell_9_1 extends Cell {}
one sig Cell_9_2 extends Cell {}
one sig Cell_9_3 extends Cell {}
one sig Cell_9_4 extends Cell {}
one sig Cell_9_5 extends Cell {}
one sig Cell_9_6 extends Cell {}
one sig Cell_9_7 extends Cell {}
one sig Cell_9_8 extends Cell {}
one sig Cell_9_9 extends Cell {}
fact matrix_adj {
  Cell_0_0.vnext = Cell_0_1
  Cell_0_1.vnext = Cell_0_2
  Cell_0_2.vnext = Cell_0_3
  Cell_0_3.vnext = Cell_0_4
  Cell_0_4.vnext = Cell_0_5
  Cell_0_5.vnext = Cell_0_6
  Cell_0_6.vnext = Cell_0_7
  Cell_0_7.vnext = Cell_0_8
  Cell_0_8.vnext = Cell_0_9
  no Cell_0_9.vnext
  Cell_1_0.vnext = Cell_1_1
  Cell_1_1.vnext = Cell_1_2
  Cell_1_2.vnext = Cell_1_3
  Cell_1_3.vnext = Cell_1_4
  Cell_1_4.vnext = Cell_1_5
  Cell_1_5.vnext = Cell_1_6
  Cell_1_6.vnext = Cell_1_7
  Cell_1_7.vnext = Cell_1_8
  Cell_1_8.vnext = Cell_1_9
  no Cell_1_9.vnext
  Cell_2_0.vnext = Cell_2_1
  Cell_2_1.vnext = Cell_2_2
  Cell_2_2.vnext = Cell_2_3
  Cell_2_3.vnext = Cell_2_4
  Cell_2_4.vnext = Cell_2_5
  Cell_2_5.vnext = Cell_2_6
  Cell_2_6.vnext = Cell_2_7
  Cell_2_7.vnext = Cell_2_8
  Cell_2_8.vnext = Cell_2_9
  no Cell_2_9.vnext
  Cell_3_0.vnext = Cell_3_1
  Cell_3_1.vnext = Cell_3_2
  Cell_3_2.vnext = Cell_3_3
  Cell_3_3.vnext = Cell_3_4
  Cell_3_4.vnext = Cell_3_5
  Cell_3_5.vnext = Cell_3_6
  Cell_3_6.vnext = Cell_3_7
  Cell_3_7.vnext = Cell_3_8
  Cell_3_8.vnext = Cell_3_9
  no Cell_3_9.vnext
  Cell_4_0.vnext = Cell_4_1
  Cell_4_1.vnext = Cell_4_2
  Cell_4_2.vnext = Cell_4_3
  Cell_4_3.vnext = Cell_4_4
  Cell_4_4.vnext = Cell_4_5
  Cell_4_5.vnext = Cell_4_6
  Cell_4_6.vnext = Cell_4_7
  Cell_4_7.vnext = Cell_4_8
  Cell_4_8.vnext = Cell_4_9
  no Cell_4_9.vnext
  Cell_5_0.vnext = Cell_5_1
  Cell_5_1.vnext = Cell_5_2
  Cell_5_2.vnext = Cell_5_3
  Cell_5_3.vnext = Cell_5_4
  Cell_5_4.vnext = Cell_5_5
  Cell_5_5.vnext = Cell_5_6
  Cell_5_6.vnext = Cell_5_7
  Cell_5_7.vnext = Cell_5_8
  Cell_5_8.vnext = Cell_5_9
  no Cell_5_9.vnext
  Cell_6_0.vnext = Cell_6_1
  Cell_6_1.vnext = Cell_6_2
  Cell_6_2.vnext = Cell_6_3
  Cell_6_3.vnext = Cell_6_4
  Cell_6_4.vnext = Cell_6_5
  Cell_6_5.vnext = Cell_6_6
  Cell_6_6.vnext = Cell_6_7
  Cell_6_7.vnext = Cell_6_8
  Cell_6_8.vnext = Cell_6_9
  no Cell_6_9.vnext
  Cell_7_0.vnext = Cell_7_1
  Cell_7_1.vnext = Cell_7_2
  Cell_7_2.vnext = Cell_7_3
  Cell_7_3.vnext = Cell_7_4
  Cell_7_4.vnext = Cell_7_5
  Cell_7_5.vnext = Cell_7_6
  Cell_7_6.vnext = Cell_7_7
  Cell_7_7.vnext = Cell_7_8
  Cell_7_8.vnext = Cell_7_9
  no Cell_7_9.vnext
  Cell_8_0.vnext = Cell_8_1
  Cell_8_1.vnext = Cell_8_2
  Cell_8_2.vnext = Cell_8_3
  Cell_8_3.vnext = Cell_8_4
  Cell_8_4.vnext = Cell_8_5
  Cell_8_5.vnext = Cell_8_6
  Cell_8_6.vnext = Cell_8_7
  Cell_8_7.vnext = Cell_8_8
  Cell_8_8.vnext = Cell_8_9
  no Cell_8_9.vnext
  Cell_9_0.vnext = Cell_9_1
  Cell_9_1.vnext = Cell_9_2
  Cell_9_2.vnext = Cell_9_3
  Cell_9_3.vnext = Cell_9_4
  Cell_9_4.vnext = Cell_9_5
  Cell_9_5.vnext = Cell_9_6
  Cell_9_6.vnext = Cell_9_7
  Cell_9_7.vnext = Cell_9_8
  Cell_9_8.vnext = Cell_9_9
  no Cell_9_9.vnext
  Cell_0_0.hnext = Cell_1_0
  Cell_1_0.hnext = Cell_2_0
  Cell_2_0.hnext = Cell_3_0
  Cell_3_0.hnext = Cell_4_0
  Cell_4_0.hnext = Cell_5_0
  Cell_5_0.hnext = Cell_6_0
  Cell_6_0.hnext = Cell_7_0
  Cell_7_0.hnext = Cell_8_0
  Cell_8_0.hnext = Cell_9_0
  no Cell_9_0.hnext
  Cell_0_1.hnext = Cell_1_1
  Cell_1_1.hnext = Cell_2_1
  Cell_2_1.hnext = Cell_3_1
  Cell_3_1.hnext = Cell_4_1
  Cell_4_1.hnext = Cell_5_1
  Cell_5_1.hnext = Cell_6_1
  Cell_6_1.hnext = Cell_7_1
  Cell_7_1.hnext = Cell_8_1
  Cell_8_1.hnext = Cell_9_1
  no Cell_9_1.hnext
  Cell_0_2.hnext = Cell_1_2
  Cell_1_2.hnext = Cell_2_2
  Cell_2_2.hnext = Cell_3_2
  Cell_3_2.hnext = Cell_4_2
  Cell_4_2.hnext = Cell_5_2
  Cell_5_2.hnext = Cell_6_2
  Cell_6_2.hnext = Cell_7_2
  Cell_7_2.hnext = Cell_8_2
  Cell_8_2.hnext = Cell_9_2
  no Cell_9_2.hnext
  Cell_0_3.hnext = Cell_1_3
  Cell_1_3.hnext = Cell_2_3
  Cell_2_3.hnext = Cell_3_3
  Cell_3_3.hnext = Cell_4_3
  Cell_4_3.hnext = Cell_5_3
  Cell_5_3.hnext = Cell_6_3
  Cell_6_3.hnext = Cell_7_3
  Cell_7_3.hnext = Cell_8_3
  Cell_8_3.hnext = Cell_9_3
  no Cell_9_3.hnext
  Cell_0_4.hnext = Cell_1_4
  Cell_1_4.hnext = Cell_2_4
  Cell_2_4.hnext = Cell_3_4
  Cell_3_4.hnext = Cell_4_4
  Cell_4_4.hnext = Cell_5_4
  Cell_5_4.hnext = Cell_6_4
  Cell_6_4.hnext = Cell_7_4
  Cell_7_4.hnext = Cell_8_4
  Cell_8_4.hnext = Cell_9_4
  no Cell_9_4.hnext
  Cell_0_5.hnext = Cell_1_5
  Cell_1_5.hnext = Cell_2_5
  Cell_2_5.hnext = Cell_3_5
  Cell_3_5.hnext = Cell_4_5
  Cell_4_5.hnext = Cell_5_5
  Cell_5_5.hnext = Cell_6_5
  Cell_6_5.hnext = Cell_7_5
  Cell_7_5.hnext = Cell_8_5
  Cell_8_5.hnext = Cell_9_5
  no Cell_9_5.hnext
  Cell_0_6.hnext = Cell_1_6
  Cell_1_6.hnext = Cell_2_6
  Cell_2_6.hnext = Cell_3_6
  Cell_3_6.hnext = Cell_4_6
  Cell_4_6.hnext = Cell_5_6
  Cell_5_6.hnext = Cell_6_6
  Cell_6_6.hnext = Cell_7_6
  Cell_7_6.hnext = Cell_8_6
  Cell_8_6.hnext = Cell_9_6
  no Cell_9_6.hnext
  Cell_0_7.hnext = Cell_1_7
  Cell_1_7.hnext = Cell_2_7
  Cell_2_7.hnext = Cell_3_7
  Cell_3_7.hnext = Cell_4_7
  Cell_4_7.hnext = Cell_5_7
  Cell_5_7.hnext = Cell_6_7
  Cell_6_7.hnext = Cell_7_7
  Cell_7_7.hnext = Cell_8_7
  Cell_8_7.hnext = Cell_9_7
  no Cell_9_7.hnext
  Cell_0_8.hnext = Cell_1_8
  Cell_1_8.hnext = Cell_2_8
  Cell_2_8.hnext = Cell_3_8
  Cell_3_8.hnext = Cell_4_8
  Cell_4_8.hnext = Cell_5_8
  Cell_5_8.hnext = Cell_6_8
  Cell_6_8.hnext = Cell_7_8
  Cell_7_8.hnext = Cell_8_8
  Cell_8_8.hnext = Cell_9_8
  no Cell_9_8.hnext
  Cell_0_9.hnext = Cell_1_9
  Cell_1_9.hnext = Cell_2_9
  Cell_2_9.hnext = Cell_3_9
  Cell_3_9.hnext = Cell_4_9
  Cell_4_9.hnext = Cell_5_9
  Cell_5_9.hnext = Cell_6_9
  Cell_6_9.hnext = Cell_7_9
  Cell_7_9.hnext = Cell_8_9
  Cell_8_9.hnext = Cell_9_9
  no Cell_9_9.hnext
}
fact {
  let next = hnext {
    some c1: from[Cell_0_0, next] {
      all_white[range[from[Cell_0_0, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 3]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_0_1, next] {
      all_white[range[from[Cell_0_1, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 2]
        some c1: c2.next.^next {
          all_white[range[c2.next.^next, c1.~next, next]]
          some c2: c1.^next {
            all_black[range[c1, c2, next], 2]
            all_white[c2.^next]
          }
        }
      }
    }
    some c1: from[Cell_0_2, next] {
      all_white[range[from[Cell_0_2, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 1]
        some c1: c2.next.^next {
          all_white[range[c2.next.^next, c1.~next, next]]
          some c2: c1.^next {
            all_black[range[c1, c2, next], 1]
            some c1: c2.next.^next {
              all_white[range[c2.next.^next, c1.~next, next]]
              some c2: c1.^next {
                all_black[range[c1, c2, next], 1]
                all_white[c2.^next]
              }
            }
          }
        }
      }
    }
    some c1: from[Cell_0_3, next] {
      all_white[range[from[Cell_0_3, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 3]
        some c1: c2.next.^next {
          all_white[range[c2.next.^next, c1.~next, next]]
          some c2: c1.^next {
            all_black[range[c1, c2, next], 3]
            all_white[c2.^next]
          }
        }
      }
    }
    some c1: from[Cell_0_4, next] {
      all_white[range[from[Cell_0_4, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 5]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_0_5, next] {
      all_white[range[from[Cell_0_5, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 7]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_0_6, next] {
      all_white[range[from[Cell_0_6, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 7]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_0_7, next] {
      all_white[range[from[Cell_0_7, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 7]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_0_8, next] {
      all_white[range[from[Cell_0_8, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 7]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_0_9, next] {
      all_white[range[from[Cell_0_9, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 5]
        all_white[c2.^next]
      }
    }
  }
  let next = vnext {
    some c1: from[Cell_0_0, next] {
      all_white[range[from[Cell_0_0, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 4]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_1_0, next] {
      all_white[range[from[Cell_1_0, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 6]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_2_0, next] {
      all_white[range[from[Cell_2_0, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 7]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_3_0, next] {
      all_white[range[from[Cell_3_0, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 9]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_4_0, next] {
      all_white[range[from[Cell_4_0, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 2]
        some c1: c2.next.^next {
          all_white[range[c2.next.^next, c1.~next, next]]
          some c2: c1.^next {
            all_black[range[c1, c2, next], 7]
            all_white[c2.^next]
          }
        }
      }
    }
    some c1: from[Cell_5_0, next] {
      all_white[range[from[Cell_5_0, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 1]
        some c1: c2.next.^next {
          all_white[range[c2.next.^next, c1.~next, next]]
          some c2: c1.^next {
            all_black[range[c1, c2, next], 6]
            all_white[c2.^next]
          }
        }
      }
    }
    some c1: from[Cell_6_0, next] {
      all_white[range[from[Cell_6_0, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 2]
        some c1: c2.next.^next {
          all_white[range[c2.next.^next, c1.~next, next]]
          some c2: c1.^next {
            all_black[range[c1, c2, next], 4]
            all_white[c2.^next]
          }
        }
      }
    }
    some c1: from[Cell_7_0, next] {
      all_white[range[from[Cell_7_0, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 3]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_8_0, next] {
      all_white[range[from[Cell_8_0, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 1]
        all_white[c2.^next]
      }
    }
    some c1: from[Cell_9_0, next] {
      all_white[range[from[Cell_9_0, next], c1.~next, next]]
      some c2: c1.^next {
        all_black[range[c1, c2, next], 2]
        all_white[c2.^next]
      }
    }
  }
}
run{} for 5 int
