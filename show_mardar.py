# -*- coding: utf-8 -*-
execfile("show.py")
load("mardar.xml")

PLACE = get("Place").one_to_one(u"海岸 裏山 公園 河川敷".split())
def clean(s):
    return s.replace("$0", "")

def to_time(s):
    v = int(re.search("\d+", s[0]).group())
    #h = v / 2 + 7
    #m = 3 if (v % 2 == 1) else 0
    h = 7 + v
    m = 0
    return "%d:%d0" % (h, m)

def show_t(time):
    print to_time(time),
    UtilList([time]).join(get("who")).map(clean).print_unwords()
    print u"「%sへ行く」" % UtilList([time]).join(get("where")).join(PLACE).as_scaler()
    print u"聞いていた人=",
    UtilList([time]).join(get("targets")).map(clean).print_unwords()

"""
// whoと同じ場所にいた可能性があるのは？
fun same_place(self: Person, who: Person): Person{
	let where = (self.belief)[self].last {
		who.where.~where + {p: Person | no p.where} - who
	}
}
"""
def same_place(self, who):
    where = get("belief").bjoin(self).bjoin(self).join(get("Mardar"))
    return (
        who.join(where).join(where.reverse()).add(
        get("Person").filter(lambda p: len(p.join(where)) == 0)
        ).remove(who)
    )


def main():
    targets = get("targets")
    print "Me"
    times = targets.join(get("Me"))
    for t in times:
        show_t(t)
    print "Ruby"
    times = targets.join(get("Ruby"))
    for t in times:
        show_t(t)
    print "Python"
    times = targets.join(get("Python"))
    for t in times:
        show_t(t)

main()


if 0:
    flag = get("flag").group_by(3, lambda k, rs: [k, rs.trans(1, 2)])
    pid = get("$step_pid").trans(0, 1, 0)
    turn = get("turn").trans(2, 1, 2)
    proc = get("proc").group_by(3, lambda k, xs: [k, xs.trans(1, 2)]).to_int(0).sort(2).trans(0, 1, 0)

    table = proc.join(pid).join(turn).join(flag)
    table.map(
        lambda t, ((_1, pc0), (_2, pc1)), pid, turn, ((_3, f0), (_4, f1)):
            "%(t)s: pc0=%(pc0)s, pc1=%(pc1)s, pid=%(pid)s turn=%(turn)s f0=%(f0)s f1=%(f1)s" % locals()
        ).print_unlines()
