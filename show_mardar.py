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
