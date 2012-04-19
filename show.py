import bs4
import re
from collections import defaultdict

def load(s=None):
    global soup
    if s == None:
        s = raw_input("filename> ")

    soup = bs4.BeautifulSoup(file(s))


def _is_two_dim(obj):
    if isinstance(obj, list):
        if isinstance(obj[0], list):
            return True
    return False


class AlloyList(list):
    def filter(self, f):
        return AlloyList(args for args in self if f(*args))

    def trans(self, *cols):
        return AlloyList([args[c] for c in cols] for args in self)

    def sort(self, *cols):
        return AlloyList(sorted(self, key=lambda x: [x[c] for c in cols]))

    def to_int(self, *cols):
        def _int(s):
            return int(re.search("\d+", s).group())
        return AlloyList(
            args + [_int(args[c]) for c in cols] for args in self)

    def join(self, al):
        assert _is_two_dim(al)
        return AlloyList(
            lhs[:-1] + rhs[1:]
            for lhs in self for rhs in al
            if lhs[-1] == rhs[0])

    def map(self, f):
        return AlloyList(f(*args) for args in self)

    def group_by(self, idx, f=lambda *x: x):
        assert isinstance(idx, int)
        group = defaultdict(AlloyList)
        for r in self:
            group[r[idx]].append(r)
        result = AlloyList()
        for key in sorted(group.keys()):
            result.append(f(key, group[key]))
        return result

    def reverse(self):
        return AlloyList(list(reversed(r)) for r in self)

    def print_unlines(self):
        print "\n".join(str(r) for r in self)

def get_field(label):
    return AlloyList(
        [x.attrs["label"] for x in r.findAll("atom")]
        for r in soup.find("field", label=label).findAll("tuple"))

def get_skolem(label):
    return AlloyList(
        [x.attrs["label"] for x in r.findAll("atom")]
        for r in soup.find("skolem", label=label).findAll("tuple"))

def get_sig(label):
    return AlloyList(
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
    return AlloyList([[label]])

