use IO, List, Collectives;

config const numRounds = 20;

class Monkey {
  const id: int,
        op: owned MathOp,
        divisor: int,
        targetMonkey: 2*int;

  var items: [0..1] list(int, parSafe=true),
      current = 0, next = 1,
      numInspected: int;

  proc currentItems() ref {
    return items[current];
  }

  proc nextItems() ref {
    return items[next];
  }

  proc swapItems() {
    current <=> next;
  }
}

const Monkeys = readMonkeys(),
      numMonkeys = Monkeys.size;

var canFinishTurn: sync int = 0;

var bar = new barrier(numMonkeys);

coforall monkey in Monkeys {

  for 1..numRounds {
    monkey.processItems(canFinishTurn);
    bar.barrier();
    monkey.swapItems();
    bar.barrier();
  }
}

const (max, loc) = maxloc reduce zip(Monkeys.numInspected, Monkeys.domain);

Monkeys[loc].numInspected = 0;
const max2 = max reduce Monkeys.numInspected;

writeln(max * max2);

proc Monkey.processItems(canFinishTurn) {

  while (canFinishTurn.readXX() != id || currentItems().size > 0) {

    while currentItems().size > 0 {
      var item = currentItems().popBack();
      numInspected += 1;

      item = op.apply(item);
      item /= 3;

      const target = targetMonkey(item % divisor == 0);

      if (target < id) {
        Monkeys[target].nextItems().pushBack(item);
      } else {
        Monkeys[target].currentItems().pushBack(item);
      }
    }
  }

  canFinishTurn.writeFF((id+1) % numMonkeys);
}

class MathOp {
  proc apply(item): item.type {
    halt("We should never end up calling '.apply' on the base class");
  }
}

class SquareOp: MathOp {
  override proc apply(item) {
    return item * item;
  }
}

class AddOp: MathOp {
  var val;
  override proc apply(item) {
    return item + val;
  }
}

class MulOp: MathOp {
  var val;
  override proc apply(item) {
    return item * val;
  }
}

proc opStringsToOp(operation, operand) {
  if operation == "+" {
    return new AddOp(operand:int): MathOp;
  } else {  // operation is "*"
    if operand == "old" {
      return new SquareOp(): MathOp;
    } else {
      return new MulOp(operand:int): MathOp;
    }
  }
}

iter readMonkeys() {
  do {
    yield new Monkey();
  } while stdin.matchNewline();
}

proc Monkey.init() {

  readf("Monkey ");
  this.id = read(int);
  readf(":");

  readf(" Starting items:");
  var tempItems: list(int);
  do {
    const val = read(int);
    tempItems.pushBack(val);
  } while stdin.matchLiteral(",");

  var operation, operand: string;
  readf(" Operation: new = old %s %s", operation, operand);
  this.op = opStringsToOp(operation, operand);

  readf(" Test: divisible by ");
  this.divisor = read(int);

  var targetMonkey: 2*int;
  readf(" If true: throw to monkey %i", targetMonkey(true));
  readf(" If false: throw to monkey %i\n", targetMonkey(false));
  this.targetMonkey = targetMonkey;

  init this;
  for item in tempItems do
    items[current].pushBack(item);
}
