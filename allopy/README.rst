========
 AlloPy
========

Utility to inspect a xml exported by Alloy.
Read doctext in allopy.py to see how to use.

REQUIREMENT
===========

BeautifulSoup 4.* http://www.crummy.com/software/BeautifulSoup/


DESIGN
======

Don't use operator overload
---------------------------

Operator overload will spoil readability.
We can overload x + y, x - y and ~x to make it looks like Alloy,
however we can't overload x ++ y, #x and x = y. Python doesn't allow them.
Most of users won't want to learn this inconsistency.


UtilList
--------

It was called 'AlloyList.'
However it cause misunderstanding that the class has exact features of Alloy's set.
It doesn't. It is similar to Alloy's set, but not equal.
Usually UtilList instance is a list of lists (called 2-dim-list in the code),
similar to Alloy's set (it is a set of tuples.)

Some methods may return non-2-dim-list, some methods doesn't return 2-dim-list.
Some methods are useful even if the list is not 2-dim.
