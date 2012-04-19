WIDTH = 10
HEIGHT = 10
HORIZONTAL_NEXT = "hnext"
VERTICAL_NEXT = "vnext"
BASE = "Cell"

print """
abstract sig %(BASE)s {
  %(HORIZONTAL_NEXT)s: lone %(BASE)s,
  %(VERTICAL_NEXT)s: lone %(BASE)s
}
""" % globals()

for x in range(WIDTH):
    for y in range(HEIGHT):
        print "one sig Cell_%d_%d extends %s {}" % (x, y, BASE)

# fact
print "fact matrix_adj {"
for x in range(WIDTH):
    for y in range(HEIGHT - 1):
        next = y + 1
        print "  Cell_%(x)d_%(y)d.%(VERTICAL_NEXT)s = Cell_%(x)d_%(next)d" % globals()
    print "  no Cell_%(x)d_%(next)d.%(VERTICAL_NEXT)s" % globals()

for y in range(HEIGHT):
    for x in range(WIDTH - 1):
        next = x + 1
        print "  Cell_%(x)d_%(y)d.%(HORIZONTAL_NEXT)s = Cell_%(next)d_%(y)d" % globals()
    print "  no Cell_%(next)d_%(y)d.%(HORIZONTAL_NEXT)s" % globals()


print "}"
