flag = get("flag").group_by(3, lambda k, rs: [k, rs.trans(1, 2)])
pid = get("$step_pid").trans(0, 1, 0)
turn = get("turn").trans(2, 1, 2)
proc = get("proc").group_by(3, lambda k, xs: [k, xs.trans(1, 2)]).to_int(0).sort(2).trans(0, 1, 0)

table = proc.join(pid).join(turn).join(flag)
table.map(
    lambda t, ((_1, pc0), (_2, pc1)), pid, turn, ((_3, f0), (_4, f1)):
        "%(t)s: pc0=%(pc0)s, pc1=%(pc1)s, pid=%(pid)s turn=%(turn)s f0=%(f0)s f1=%(f1)s" % locals()
    ).print_unlines()
