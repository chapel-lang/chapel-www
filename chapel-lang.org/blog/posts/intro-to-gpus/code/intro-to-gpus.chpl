config const n = 5; // use 5-element arrays in examples by default, for brevity

on here.gpus[0] {
  var A: [1..n] int; // declare an array with n elements
                     // (to benefit from GPUs, you'd probably want n >> 5)
  foreach i in 1..n do
    A[i] = i * 2;

  writeln("The whole array A is: ", A); 
  for i in 1..n do
    writeln("A[", i, "] = ", A[i]);
}

use GpuDiagnostics;

proc startCountingKernelLaunches() {
  resetGpuDiagnostics();
  startGpuDiagnostics();
}

proc numKernelLaunches() {
  stopGpuDiagnostics();
  var result = + reduce getGpuDiagnostics().kernel_launch;
  startCountingKernelLaunches();
  return result;
}

startCountingKernelLaunches();

on here.gpus[0] {

  var Evens = 2 * [1,2,3,4,5];
  writeln(Evens);

  // One kernel launch from the promoted initializer
  assert(numKernelLaunches() == 1);

  use Math; // Include the 'Math' module for access to 'sin' and 'pi'

  const numSamples = 10;
  var A = [i in 0..#numSamples] sin(2 * pi * i / numSamples);

  writeln(A);

  // One kernel launch from the loop expression initializer
  assert(numKernelLaunches() == 1);

  proc fib(x: int): int {
    if x <= 1 then return 1;
    return fib(x-1) + fib(x-2);
  }

  var Fibs = fib(0..#20);
  writeln(Fibs);

  // One kernel launch from the promoted expression in the initializer
  assert(numKernelLaunches() == 1);

  var rows, cols = 1..5;
  var Square: [rows, cols] int;
  foreach (r, c) in Square.indices do
      Square[r, c] = r * 10 + c;

  writeln("Original array:");
  writeln(Square);

  // Two kernel launches: one from initializing Square, one from the loop
  assert(numKernelLaunches() == 2);

  var ColSums: [cols] int;
  foreach c in cols do {
    var sum = 0;

    for r in rows do
      sum += Square[r, c];

    ColSums[c] = sum;
  }
  writeln("Column sums:");
  writeln(ColSums);

  // Two kernel launches: one from initializing ColSums, one from the loop
  assert(numKernelLaunches() == 2);

} // end of `on here.gpus[0]`

coforall loc in Locales do on loc {
  coforall gpu in here.gpus do on gpu {
    var Evens = 2 * [1,2,3,4,5];
    writeln("Even numbers computed on ", gpu, ": ", Evens);
  }
}
