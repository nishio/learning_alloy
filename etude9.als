// combinator logic

abstract sig Bird{
	apply: Bird -> Bird
}

one sig K extends Bird{}

one sig S extends Bird{}


fact {
	all x, y: Bird | K.apply.x.apply.y = x
  all x, y, z: Bird {
    S.apply.x.apply.y.apply.z =
    x.apply.z.apply.(y.apply.z)
  }
}
/*
pred equal(f, g: Bird){
	f in g.same_birds and g in f.same_birds
}

pred apply(f, g: Bird) {
	one a: Apply {
		a.x = f and a.y = g
  }
}
*/
run {} for 10 Bird

// 	//some b: Bird | all x: Bird | b.apply.x = K

