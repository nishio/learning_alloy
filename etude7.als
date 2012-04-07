// A.1.2

assert NotEmpty {
  all r: univ -> univ |
    some r iff (some x, y: univ | x -> y in r)
}

assert Trans {
  all r: univ -> univ {
    (r.r in r) iff (
      all x, y, z: univ {
        (x -> y) in r and (y -> z) in r
        => (x -> z) in r
      }
    )
  }
}

assert NonReflect {
  all r: univ -> univ {
    (no iden & r) iff (
      all x: univ | (x -> x) not in r
    )
  }
}

assert Symmetric{
  all r: univ -> univ {
    (~r in r) iff {
      all x, y: univ | (x -> y) in r => (y -> x) in r
    }
  }
}

assert Func {
  all r: univ -> univ {
    (~r.r in iden) iff {
      //all x, y, a, b: univ {
      //  (x -> y) in r and (a -> b) in r => x != y
      //  // error
      //}
      all x: univ {
        lone x.r
      }
    } 
  }
}


assert Tansha {
  all r: univ -> univ {
    (r.~r in iden) iff {
      all x: univ {
        lone r.x
      }
    }
  }
}

assert Zeniki {
  all r: univ -> univ {
    (univ in r.univ) iff {
      all x: univ {
        some x.r
      }
    }
  }
}

assert Zensha {
  all r: univ -> univ {
    (univ in univ.r) iff {
      all x: univ {
        some r.x
      }
    }
  }
}
