open util/ordering[Col] as cols
open util/ordering[Row] as rows

abstract sig Region {
	index: Int
}
sig Col extends Region {
	cell: Row -> Color
}{
	index >= 0
	index <= 9
}
sig Row extends Region {}{
	index >= 0
	index <= 9
}

fact {
	all r: Col - last {
		add[r.index, 1] = r.next.index
	}
	all r: Row - last {
		add[r.index, 1] = r.next.index
	}
}

enum Color { Black, White }

fact {
	all c: Col, r: Row | one cell [c, r]
}

-- both Row and Col
pred prev_is_white(c: Col, r: Row, prev: Region->Region) {
	// トリック: prevがCol->ColでもRowに使ってよい
	// なぜなら空集合が返るのでin Whiteが成立するから
	cell[prev[c], r] + cell[c, prev[r]] in White
}

pred no_prev(c: Col, r: Row, prev: Region->Region) {
	// トリック: nextがCol->ColでもRowに使ってよい
	// なぜなら空集合が返るのでnoが成立するから
	no prev[c] and no prev[r]
}

// c, rがブロックの先頭であるかどうか
pred is_black_head(c: Col, r: Row, prev: Region->Region) {
	// 最初のRowであるか、または前のRowのセルが白い
	no_prev[c, r, prev] or prev_is_white[c, r, prev]
	// このセルは黒い
	cell[c, r] in Black
}
fun get_block_end(start: Region, size: Int): Region{
	plus[start.index, minus[size, 1]][index]
}

fun IntTo(i: Int, R: Region): Region{
	index.i & R
}

pred sorted(xs: Int, s: seq Int){
	// sの要素はxsと同一
	s.elems = xs
	// sは単調増加
	all i: s.butlast.inds | lt [s[i], s[plus[i, 1]]]	
}

-- about rows or cols

pred headsSeqInRow (r: Row, s: seq Col) {
	sorted[
		{ c: Col | is_black_head[c, r, cols/prev]}.index,
		s.index]
}
pred headsSeqInCol (c: Col, s: seq Row) {
	sorted[
		{ r: Row | is_black_head[c, r, rows/prev]}.index,
		s.index]
}


fun range(R: Region, start, end: Int): Region{
	{r: R | start =< r.index and r.index =< end}
}


pred rowHint (j: Int, sizes: seq Int) {
	let r = IntTo[j, Row] | some cs: seq Col {
		#sizes = #cs
		// csは黒ブロックの先頭の位置のソートされたシークエンス
		headsSeqInRow [r, cs]
		all i: sizes.inds {
			// cs[i]をstart, startの位置にsize[i]を足して1を引いた位置にあるColをendと呼ぶ
			let start = cs [i], end = Col & get_block_end[start, sizes[i]] {
				// endが存在する
				some end
				// startからendまで全部黒
				all c: range[Col, start.index, end.index] | cell [c, r] in Black
				// endの次がないか、または白
				no end.next or cell [end.next, r] in White
			}
		}
	}
}
pred colHint (j: Int, sizes: seq Int) {
	let c = IntTo[j, Col] | some rs: seq Row {
		#sizes = #rs
		headsSeqInCol [c, rs]
		all i: sizes.inds {
			let start = rs [i], end = Row & get_block_end[start, sizes[i]] {
				some end
				all r: range[Row, start.index, end.index] | cell [c, r] in Black
				no end.next or cell [c, end.next] in White
			}
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
