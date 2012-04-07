// A.1.5 what is tree?

sig Node {}

pred is_tree (r: Node -> Node){
	no r & iden
	no ^r & iden
	all x: Node {lone r.x}
	some root: Node {root.^r = Node - root} // reachable from root
}

run is_tree for 4
