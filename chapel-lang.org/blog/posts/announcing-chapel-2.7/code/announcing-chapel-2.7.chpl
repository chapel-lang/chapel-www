use Random;

config const N = 1000,
       print = true;

proc main() {
  const scalar = (new randomStream(real)).next();
  var Arr, Res: [1..N] real;

  fillRandom(Arr);
  kernel(Res, Arr, scalar);
  if print then writeln(Res);
}

proc kernel(ref Res, Arr, scalar) {
  foreach (r, a) in zip(Res, Arr) {
    r = a ** scalar;
  }
}
