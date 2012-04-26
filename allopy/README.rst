========
 AlloPy
========

Utility to inspect a xml exported by Alloy.


DESIGN
======

Don't use operator overload
---------------------------

Operator overload will spoil readability.
We can overload x + y, x - y and ~x to make it looks like Alloy,
however we can't overload *x, #x and x = y. Python doesn't allow them.
You and most of users won't want to learn this inconsistency.
