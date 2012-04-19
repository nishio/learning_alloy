fun filter_middle(rs: Int->Int->Int, key: Int): Int->Int{
	some r: Int->Int{
		all x: Int {
			x.rs[key] = r[x]
		}
	}
}

run {
	some r: Int->Int->Int {
		some x:Int | (x -> 1 -> 3) in r
		some x:Int | (x -> 2 -> 4) in r
	}
}
