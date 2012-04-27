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
    def filter(self, f):
        return UtilList(args for args in self if f(*args))

    def trans(self, *cols):
        return UtilList([args[c] for c in cols] for args in self)

    def sort(self, *cols):
        return UtilList(sorted(self, key=lambda x: [x[c] for c in cols]))

    def to_int(self, *cols):
        def _int(s):
            return int(re.search("\d+", s).group())
        return UtilList(
            args + [_int(args[c]) for c in cols] for args in self)

    def join(self, al):
        assert _is_two_dim(al), "%r is not 2-dim list" % al
        return UtilList(
            lhs[:-1] + rhs[1:]
            for lhs in self for rhs in al
            if lhs[-1] == rhs[0])

    def bjoin(self, al):
        "backword join. x.bjoin(y) equals y.join(x), Alloy's y.x and x[y]"
        return al.join(self)

    def map(self, f):
        return UtilList(f(*args) for args in self)

    def group_by(self, idx, f=lambda *x: x):
        assert isinstance(idx, int)
        group = defaultdict(UtilList)
        for r in self:
            group[r[idx]].append(r)
        result = UtilList()
        for key in sorted(group.keys()):
            result.append(f(key, group[key]))
        return result

    def reverse(self):
        return UtilList(list(reversed(r)) for r in self)

    def print_unlines(self):
        print "\n".join(str(r) for r in self)

    def add(self, ys):
        """x.add(y) is Alloy's x + y
        (I don't like operator overload)"""
        return UtilList(self + [y for y in ys if y not in self])

    def remove(self, ys):
        """x.remove(y) is Alloy's x - y
        (I don't like operator overload)"""
        return UtilList(x for x in self if x not in ys)

    def as_scaler(self):
        assert len(self) == 1
        assert len(self[0]) == 1
        return self[0][0]

    def one_to_one(self, ys):
        assert len(self) == len(ys)
        return UtilList(x + _ensure_list(y) for (x, y) in zip(self, ys))

    def print_unwords(self, sep=", "):
        print sep.join(str(r) for r in self)


def _ensure_list(x):
    if isinstance(x, list): return x
    return [x]

def flatten(xs):
    return reduce(lambda x, y: x + y, xs)

def get_field(label):
    fields = soup.findAll("field", label=label)
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
