import bs4
import re
from collections import defaultdict

def load(s=None):
    global soup
    if s == None:
        s = raw_input("filename> ")

    soup = bs4.BeautifulSoup(file(s))


def _is_two_dim(obj):
    if isinstance(obj, list) or isinstance(obj, UtilList):
        if isinstance(obj[0], list):
            return True
    return False


class UtilList(list):
    """List with utility methods"""
    def __repr__(self):
        return "UtilList(%s)" % list.__repr__(self)

    def filter(self, f):
        """
        >>> UtilList([[1, 2], [2, 1]]).filter(lambda x, y: x < y)
        UtilList([[1, 2]])
        """
        return UtilList(args for args in self if f(*args))

    def trans(self, *cols):
        """
        >>> UtilList([[1, "A"], [2, "B"]]).trans(1, 0)
        UtilList([['A', 1], ['B', 2]])

        >>> UtilList([[1, "A"], [2, "B"]]).trans(0, 1, 0)
        UtilList([[1, 'A', 1], [2, 'B', 2]])

        >>> UtilList([[1, "A"], [2, "B"]]).trans(0)
        UtilList([[1], [2]])
        """
        return UtilList([args[c] for c in cols] for args in self)

    def sort(self, *cols):
        """
        >>> UtilList([[2, "A"], [1, "C"], [3, "B"]]).sort(0)
        UtilList([[1, 'C'], [2, 'A'], [3, 'B']])

        >>> UtilList([[2, "A"], [1, "C"], [3, "B"]]).sort(1)
        UtilList([[2, 'A'], [3, 'B'], [1, 'C']])

        >>> UtilList([[0, 1], [0, 0], [1, 0]]).sort(0, 1)
        UtilList([[0, 0], [0, 1], [1, 0]])
        """
        return UtilList(sorted(self, key=lambda x: [x[c] for c in cols]))

    def to_int(self, *cols):
        """
        >>> UtilList([["Foo$1"], ["Foo$2"], ["Foo$3"]]).to_int(0)
        UtilList([['Foo$1', 1], ['Foo$2', 2], ['Foo$3', 3]])
        """
        def _int(s):
            return int(re.search("\d+", s).group())
        return UtilList(
            args + [_int(args[c]) for c in cols] for args in self)

    def join(self, al):
        """
        >>> UtilList([[2, "A"], [1, "C"]]).join([["A", 20], ["C", 10]])
        UtilList([[2, 20], [1, 10]])
        """
        assert _is_two_dim(al), "%r is not 2-dim list" % al
        return UtilList(
            lhs[:-1] + rhs[1:]
            for lhs in self for rhs in al
            if lhs[-1] == rhs[0])

    def bjoin(self, al):
        """
        Backword join. x.bjoin(y) equals y.join(x), Alloy's y.x and x[y]

        >>> UtilList([["A", 20], ["C", 10]]).bjoin([[2, "A"], [1, "C"]])
        UtilList([[2, 20], [1, 10]])
        """
        return UtilList(al).join(self)

    def map(self, f):
        """
        Map given function for each row. It may return not-2-dim list

        >>> UtilList([[1], [2], [3]]).map(lambda x: x * 10)
        UtilList([10, 20, 30])
        """
        return UtilList(f(*args) for args in self)

    def group_by(self, idx, f=lambda *x: x):
        """
        Make group by given column's equality. It doesn't return 2-dim list.
        >>> UtilList([[0, 0], [0, 1], [1, 2], [1, 3]]).group_by(0)
        UtilList([(0, UtilList([[0, 0], [0, 1]])), (1, UtilList([[1, 2], [1, 3]]))])
        """
        assert isinstance(idx, int)
        group = defaultdict(UtilList)
        for r in self:
            group[r[idx]].append(r)
        result = UtilList()
        for key in sorted(group.keys()):
            result.append(f(key, group[key]))
        return result

    def reverse(self):
        """
        >>> UtilList([[1, 2, 3]]).reverse()
        UtilList([[3, 2, 1]])
        """
        return UtilList(list(reversed(r)) for r in self)

    def add(self, ys):
        """
        x.add(y) is Alloy's x + y
        (I don't like operator overload)

        >>> UtilList([[1], [2]]).add([[2], [3]])
        UtilList([[1], [2], [3]])
        """
        return UtilList(self + [y for y in ys if y not in self])

    def remove(self, ys):
        """
        x.remove(y) is Alloy's x - y
        (I don't like operator overload)

        >>> UtilList([[1], [2], [3]]).remove([[2], [3]])
        UtilList([[1]])
        """
        return UtilList(x for x in self if x not in ys)

    def as_scaler(self):
        """
        >>> UtilList([[1]]).as_scaler()
        1
        """
        assert len(self) == 1
        assert len(self[0]) == 1
        return self[0][0]

    def one_to_one(self, ys):
        """
        Concatenate each row of two list of same length, each by each.

        >>> UtilList([[1], [2]]).one_to_one([[3], [4]])
        UtilList([[1, 3], [2, 4]])
        """
        assert len(self) == len(ys)
        return UtilList(x + _ensure_list(y) for (x, y) in zip(self, ys))

    def print_unlines(self):
        """
        Join with newline and print. It can take non-2-dim list.
        >>> UtilList([1, 2, 3]).print_unlines()
        1
        2
        3
        """
        print "\n".join(str(r) for r in self)

    def print_unwords(self, sep=", "):
        """
        Join with given separater (default=", ") and print. It can take non-2-dim list.
        >>> UtilList([1, 2, 3]).print_unwords()
        1, 2, 3
        """
        print sep.join(str(r) for r in self)


def _ensure_list(x):
    if isinstance(x, list): return x
    return [x]

def flatten(xs):
    return reduce(lambda x, y: x + y, xs, [])

def get_field(label):
    fields = soup.findAll("field", label=label)
    assert fields # not empty
    tuples = flatten(field.findAll("tuple") for field in fields)
    return UtilList(
        [x.attrs["label"] for x in r.findAll("atom")]
        for r in tuples)


def get_skolem(label):
    return UtilList(
        [x.attrs["label"] for x in r.findAll("atom")]
        for r in soup.find("skolem", label=label).findAll("tuple"))


def get_sig(label):
    return UtilList(
        [r.attrs["label"]]
        for r in soup.find("sig", label=label).findAll("atom"))


def get(label):
    try:
        if label[0] == "$":
            return get_skolem(label)
        return get_field(label)
    except:
        pass
    try:
        return get_sig("this/" + label)
    except:
        pass
    try:
        return get_sig(label)
    except:
        pass
    return UtilList([[label]])


def get_all_label():
    return dict(
        sig=[x.attrs["label"] for x in soup.findAll("sig")],
        field=[x.attrs["label"] for x in soup.findAll("field")],
        skolem=[x.attrs["label"] for x in soup.findAll("skolem")])


def show_label():
    data = get_all_label()
    print "sig:"
    print "\n".join("  %s" % label for label in data["sig"])
    print "field:"
    print "\n".join("  %s" % label for label in data["field"])
    print "skolem:"
    print "\n".join("  %s" % label for label in data["skolem"])


def _test():
    import doctest
    doctest.testmod()

if __name__ == "__main__":
    _test()
