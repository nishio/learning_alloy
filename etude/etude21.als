one sig Dummy {
	map: Int -> Int -> Int
}{
	all m: map{
		
	}
}

fun get_1st(r: Int->Int->Int): Int{
	r.univ.univ
}
fun get_2nd(r: Int->Int->Int): Int{
	univ.r.univ
}
fun get_3rd(r: Int->Int->Int): Int{
	univ.(univ.r)
}

run {
	some x: Int { 
		x in Int
	}
} for 5 Int
