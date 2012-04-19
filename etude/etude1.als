module nhiro/etude1

sig CommitObj {
  parent: set CommitObj
}

fact { // 自分の先祖に自分がいない
  all x: CommitObj | x not in x.^parent
}

fact { //  親は2個以下
  all x: CommitObj | #x.parent =< 2
}

fact {
  #CommitObj > 5
}

fact {
  #{x: CommitObj | #x.parent > 1} = 1
}

fact { // 親を持たないコミットオブジェクトは1個だけある
  #{x: CommitObj | #x.parent = 0} =< 1
}

pred always_success {}
run always_success for 10
