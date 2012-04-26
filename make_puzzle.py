"""
generate make_puzzle.als
"""
NUM_PERSON = 5
NUM_PRED_PER_PERSON = 2

print ("""
enum Person {%s}
""" %
", ".join("P%d" % i for i in range(NUM_PERSON)))

print """
enum Bool {T, F}
"""

print """
abstract sig Constrain{}
"""

params = ", ".join(
    "p%d_%d" % (person, pred)
    for person in range(NUM_PERSON)
    for pred in range(NUM_PRED_PER_PERSON))

# let b0 = (P0 -> p0_0)
mapper = ",\n    ".join(
    "b%d = %s"
    % (pred,
       " + ".join(
            "(P%d -> p%d_%d)"
            % (person, person, pred)
            for person in range(NUM_PERSON)))
    for pred in range(NUM_PRED_PER_PERSON))

print ("""
pred satisfy(cs: Constrain, %s: Bool){
  let %s
  {

  }
}
""" % (params, mapper))

print ("""
run {
  let answers = {
    %s: Bool |
    satisfy[Constrain, %s]}
    {

    one answers

    all x: Constrain {
      not one {
        %s: Bool |
        satisfy[Constrain - x, %s]
      }
    }
  }
}
""" % (params, params, params, params))
