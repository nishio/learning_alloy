# -*- coding: utf-8 -*-
execfile("show.py")
load("puzzle4.xml")

liars = get("is_liar").trans(0)
liars = liars.trans(0, 0).join(get("by"))
liars = liars.trans(0, 1, 0).join(get("who"))

print "liars:"
liars.print_unlines()

cowards = get("is_coward").trans(0)
cowards = cowards.trans(0, 0).join(get("by"))
cowards = cowards.trans(0, 1, 0).join(get("who"))

print "cowards:"
cowards.print_unlines()
