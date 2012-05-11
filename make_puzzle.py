"""
generate make_puzzle.als
"""
from string import Template

NUM_PERSON = 5
NUM_PRED_PER_PERSON = 1
if NUM_PRED_PER_PERSON > 2: raise NotImplementedError

CONSTRAINS = "Con Div Same".split()
assert all(c.lower() != c for c in CONSTRAINS)
VISUALIZE = True

if not VISUALIZE:
    print ("""
    enum Person {%s}
    """ %
    ", ".join("P%d" % i for i in range(NUM_PERSON)))
else:
    fields = ["%s: set Person" % c.lower() for c in CONSTRAINS]
    fields = ",\n  ".join(fields)
    people = ["one sig P%d extends Person {}" % i for i in range(NUM_PERSON)]
    people = "\n".join(people)
    facts = ["""
    (q in p.%s) <=> (
      some c: %s{
        c.by = p
        c.who = q
      }
    )""" % (c.lower(), c) for c in CONSTRAINS]
    facts = "\n".join(facts)

    print Template("""
abstract sig Person {
  $fields
}

$people

fact{
  all p, q: Person{
    $facts
  }
}
""").substitute(dict(fields=fields, people=people, facts=facts))


print """
enum Bool {T, F}
"""

if NUM_PRED_PER_PERSON == 2:
    predtype = "BBool"
    print """
enum BBool {TT, TF, FT, FF}
"""
else:
    predtype = "Bool"

print """
abstract sig Constrain{
	by: one Person,
	who: one Person
}{
	by not in who
}
"""

for c in CONSTRAINS:
    print "sig %s extends Constrain {}" % c


params = ", ".join(
    "p%d" % (person,)
    for person in range(NUM_PERSON))

# make:
# bb = (A -> a) + (B -> b) + (C -> c) + (D -> d) + (E -> e),
mapper = [
    "bb = " +
    " + ".join(
        "(P%d -> p%d)" % (i, i) for i in range(NUM_PERSON))
]


if NUM_PRED_PER_PERSON == 2:
    mapper.extend(
        [
            "b0 = bb.(TT -> T + TF -> T + FT -> F + FF -> F)",
            "b1 = bb.(TT -> T + TF -> F + FT -> T + FF -> F)",
        ]
    )

mapper = ",\n      ".join(mapper)

from string import Template
tmpl = Template("""
pred satisfy(cs: Constrain, $params: $predtype){
  let $mapper
  {

  }
}

run {
  some Constrain
  let answers = {
    $params: $predtype |
    satisfy[Constrain, $params]}
  {

    one answers

    all x: Constrain {
      not one {
        $params: $predtype |
        satisfy[Constrain - x, $params]
      }
    }
  }
}
""")

print tmpl.substitute(dict(params=params, mapper=mapper, predtype=predtype))
