use IO, List;

var Stacks = initStacks();

var num, from, to : int;
while readf("move %i from %i to %i\n", num, from, to) {

  for i in 1..num {
    const crate = Stacks[from].popBack();
    Stacks[to].pushBack(crate);
  }
}

for stack in Stacks {
  write(stack.last);
}

writeln();

iter readInitState() {
  var line: string;
  while readLine(line) && line.size > 1 do
    yield line;
}

proc initStacks() {
  const InitState = readInitState();

  param charsPerStack = 4;

  var numStacks = InitState.last.size / charsPerStack;

  enum crateID {A, B, C, D, E, F, G, H, I, J, K, L, M,
                N, O, P, Q, R, S, T, U, V, W, X, Y, Z};

  var Stacks: [1..numStacks] list(crateID);

  for i in 0..<InitState.size-1 by -1 {

    ref line = InitState[i];

    // do a zippered iteration over the stack IDs and
    // offsets where crate names will be
    for (offset, stackIdx) in zip(1..<line.size by charsPerStack, 1.. ) {

      const char = line[offset];
      if (char != " ") {  // blank means no crate here
        Stacks[stackIdx].pushBack(char: crateID);
      }

    }
  }

  return Stacks;
}
