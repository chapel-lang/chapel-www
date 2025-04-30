use Time;

config const n = 10;

config const printArrays = true,
             printTiming = true;

// generate the indices for a tridiagonal matrix of size n
iter genInds(n) {
  for i in 1..n {
    if i > 1 then
      yield (i,i-1);
    yield (i,i);
    if i < n then
      yield (i,i+1);
  }
}

const D = {1..n, 1..n},
      SD: sparse subdomain(D) = genInds(n);

var AD: [D] real = 1.0,
    AS: [SD] real = 2.0;

if printArrays {
  writeln(AD);
  writeln(AS);
}

var s: stopwatch;

s.start();
assign(AD, AS);
s.stop();

if printArrays then
  writeln(AD);

forall (i,j) in D do
  if j >= i-1 && j <= i+1 then
    assert(AD[i,j] == 2.0);
  else
    assert(AD[i,j] == 0.0);
writeln("Verification passed");

if printTiming then
  writeln("Assignment time = ", s.elapsed());

proc assign(ref a: [], b: []) where !a.isSparse() && b.isSparse() {
  a = b.IRV;
  forall (idx,val) in zip(b.domain, b) do                                   
    a[idx] = val;                                                           
/*
    forall idx in b.domain do
	    a[idx] = b[idx];
*/
}


/*
COO
===
$ ./testit --printArrays=false --n=10000
Verification passed
Assignment time = 0.243919
$ ./testit --printArrays=false --n=100000
Verification passed
Assignment time = 47.5447

With optimization:
$ ./testit --printArrays=false --n=10000
Verification passed
Assignment time = 0.008409
$ ./testit --printArrays=false --n=100000
Verification passed
Assignment time = 15.0196

CSR
===

without optimization:
* compiler error due to missing dsi routines...

With optimization:
./testit --printArrays=false --n=10000
Verification passed
Assignment time = 0.008868
HPE-CXQDMKX7JG (main)$ ./testit --printArrays=false --n=100000
Verification passed
Assignment time = 13.7818
*/

