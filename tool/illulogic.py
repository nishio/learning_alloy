"""
Solve Illust Logic
"""

print """// Illust Logic
abstract sig Cell {
  color: Color,
  hnext: lone Cell,
  vnext: lone Cell
}

enum Color {Black, White}

fun range(start, end : Cell, r: Cell -> Cell): Cell{
  (start + start.^r) & (end.^(~r) + end)
}

pred all_black(cells : Cell, size: Int){
  #cells = size
  all c: cells{
    c.color = Black
  }
}

pred all_white(cells : Cell){
  all c: cells{
    c.color = White
  }
}

fun from(start: Cell, next: Cell -> Cell): Cell{
  start + start.^next
}
"""

indent = 0
def p(s, i=0):
    global indent
    if i < 0: indent += i
    print "  " * indent + s
    if i > 0: indent += i


WIDTH = 10
HEIGHT = 10
HORIZONTAL_NEXT = "hnext"
VERTICAL_NEXT = "vnext"
BASE = "Cell"

for x in range(WIDTH):
    for y in range(HEIGHT):
        p("one sig Cell_%d_%d extends %s {}" % (x, y, BASE))

# fact
p("fact matrix_adj {", 1)
for x in range(WIDTH):
    for y in range(HEIGHT - 1):
        next = y + 1
        p("Cell_%(x)d_%(y)d.%(VERTICAL_NEXT)s = Cell_%(x)d_%(next)d" % globals())
    p("no Cell_%(x)d_%(next)d.%(VERTICAL_NEXT)s" % globals())

for y in range(HEIGHT):
    for x in range(WIDTH - 1):
        next = x + 1
        p("Cell_%(x)d_%(y)d.%(HORIZONTAL_NEXT)s = Cell_%(next)d_%(y)d" % globals())
    p("no Cell_%(next)d_%(y)d.%(HORIZONTAL_NEXT)s" % globals())

p("}", -1)


def rule(cells, numbers):
    v_id = 0
    n = numbers.pop(0)
    p("some c1: %(cells)s {" % locals(), 1)
    p("all_white[range[%(cells)s, c1.~next, next]]" % locals())
    p("some c2: c1.^next {", 1)
    p("all_black[range[c1, c2, next], %d]" % n)
    if numbers:
        rule("c2.next.^next", numbers)
    else:
        p("all_white[c2.^next]")
    p("}", -1)
    p("}", -1)

def main():
    p("fact {", 1)
    p("let next = hnext {", 1)
    raw_hints = [[3], [2, 2], [1, 1, 1], [3, 3], [5], [7], [7], [7], [7], [5]]
    for i in range(10):
        rule("from[Cell_0_%d, next]" % i, raw_hints[i])
    p("}", -1)
    
    p("let next = vnext {", 1)
    col_hints = [[4], [6], [7], [9], [2, 7], [1, 6], [2, 4], [3], [1], [2]]
    for i in range(10):
        rule("from[Cell_%d_0, next]" % i, col_hints[i])
    p("}", -1)

    p("}", -1)
    p("run{} for 5 int")

    
main()
