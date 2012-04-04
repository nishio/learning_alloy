fact {
 #univ = 4
}
sig A {}
sig B {}
sig C {}
sig D {}
fact {
  #A = 1 && #B = 1 && #C = 1 && #D = 1
}

run {
   some r: univ -> univ {
    some r
    r.r in r
    no iden & r
    ~r in r
    ~r.r in iden
    r.~r in iden
   univ in r.univ
   univ in univ.r
  }
} for 4
