open util/ordering[SmallInt]

one sig Root{
  cell: Int -> Color -> Int
}{
  all x: cell.univ.univ | in_ten[x]
  all y: univ.(univ.cell) | in_ten[y]
  let ten = {x: Int | in_ten[x]}{
    all x, y: ten{
      one x.cell.y
    }
  }
}

pred in_ten(x: Int){
  one x
  0 <= x and x < 10  // notice: for 5 Int required
}

enum Color { Black, White }


fun getCol(i: Int): seq Color{
  ~(i.(Root.cell))
}
fun getRow(i: Int): seq Color{
  (Root.cell).i
}


// 指定されたセルが黒ブロックの先頭である
pred is_black_head(line: seq Color, pos: Int) {
  // 直前のブロックが黒でない(存在しない場合を含む)
  prev_is_not_black[line, pos]
  // このセルは存在していて黒い
  let this_ = line[pos]{
    one this_ and this_ in Black
  }
}

pred sorted(xs: SmallInt, ss: seq SmallInt){
  // ssの要素はxsと同一
  ss.elems = xs
  // ssは単調増加
  all i: ss.butlast.inds | lt [ss[i], ss[plus[i, 1]]]
}

// ブロック先頭の集合
fun get_heads(line: seq Color): SmallInt{
  {i: SmallInt | is_black_head[line, i.to_int]}
}

fun get_end(start: Int, size: Int): Int{
  plus[start, minus[size, 1]]
}

pred all_black(line: seq Color, start: Int, end: Int){
  all i: Int {
    (start =< i and i =< end) => (line[i] = Black)
  }
}

// 黒でない(存在しないか白である)
pred is_not_black(c: Color){
  no c or c in White
}
// 直前のブロックが黒でない(存在しないか白である)
pred prev_is_not_black(line: seq Color, pos: Int) {
  let prev = minus[pos, 1] {
    is_not_black[line[prev]]
  }
}
// 直後のブロックが黒でない(存在しないか白である)
pred next_is_not_black(line: seq Color, pos: Int) {
  let next = plus[pos, 1]{
    is_not_black[line[next]]
  }
}

sig SmallInt{}
fun from_int (i: Int): SmallInt {
  {x: SmallInt | #(x.prevs) = i}
}

fun to_int (x: SmallInt): Int {
  #(x.prevs)
}

pred hint(line: seq Color, sizes: seq Int){
  some heads: seq SmallInt {
    #heads = #sizes
    sorted[get_heads[line], heads]
    all i: sizes.inds {
      let start = heads[i], 
				end = from_int[get_end[start.to_int, sizes[i]]] {
        some line[end.to_int]
        all_black[line, start.to_int, end.to_int]
        next_is_not_black[line, end.to_int]
      }
    }
  }
}
pred colHint (i: Int, sizes: seq Int) {
  hint[getCol[i], sizes]
}
pred rowHint (i: Int, sizes: seq Int) {
  hint[getRow[i], sizes]
}

run{
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
} for 5 Int, exactly 10 SmallInt
