# -*- coding: utf-8 -*-
import re
cells = re.findall("""<tuple> <atom label="Col\$(\d+)"/> <atom label="Row\$(\d+)"/> <atom label="(.+)"/> </tuple>""", open("a.xml").read())

result = [[0] * 10 for _ in range(10)]
for (x, y, c) in cells:
    x = int(x)
    y = int(y)
    if c == "Black$0":
        result[y][x] = "■"
    else:
        result[y][x] = "　"

print "\n".join("".join(row) for row in result)
