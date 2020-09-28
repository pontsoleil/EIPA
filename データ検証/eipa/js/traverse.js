var graph = {
  alpha: {
      v: 'alpha',
      out: ['a', 'b']
  },
  a: {
      v: 'a',
      out: []
  },
  b: {
      v: 'b',
      out: ['c', 'e']
  },
  c: {
    v: 'c',
    out: ['d']
  },
  d: {
    v: 'd',
    out: []
  },
  e: {
    v: 'e',
    out: ['f', 'g']
  },
  f: {
    v: 'f',
    out: []
  },
  g: {
    v: 'g',
    out: []
  }
};

var traverse = function(tree, path, current) {
  //process current node here
  console.log(path+'/'+current.v);
  //visit children of current
  for (var cki in current.out) {
    var ck = current.out[cki];
    var child = tree[ck];
    traverse(tree, path+'/'+current.v, child);
  }
}

//call on root node
traverse(graph, '', graph["alpha"]);