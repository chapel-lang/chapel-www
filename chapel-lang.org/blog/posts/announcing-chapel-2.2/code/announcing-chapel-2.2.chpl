 use IO;

 const infile = openReader("file.txt");

 forall line in infile.lines(targetLocales=Locales, stripNewline=true) do
   writeln("Locale ", here.id, " read: ", line);

 use PrecisionSerializer;

 const arr = [1.123456789, 2.123456789, 3.123456789, 4.123456789],
       fourPaddedDigits = new precisionSerializer(precision=3, padding=9);

 stdout.withSerializer(fourPaddedDigits).writeln(arr);
 // prints: '    1.123     2.123     3.123     4.123'

config const n = 10;

const D = {1..n, 1..n};
var A, B: [D] real;
B = [(i,j) in D] (i-1) + (j-1)/10.0;

A[1..9, 1..9] = B[2..10, 2..10];  // copy between sub-arrays of A and B
A[10, ..] = B[3, ..];             // copy row 3 of B to row 10 of A

writeln(A);

on Locales.last {
  var localA = A;  // make a local copy of A on this locale
  // compute with 'localA'
}

proc genTriple(): [1..3] real {
  var trip: [1..3] real = [1.2, 3.4, 5.6];
  return trip;
}

var myTriple: [1..3] real = genTriple();
writeln(myTriple);

const target = if here.gpus.size > 0 then here.gpus[0] else here;

on target {
  var Arr: [1..1_000_000] int;

  @gpu.assertEligible
  foreach elem in Arr do
    elem += 1;

  writeln(+ reduce Arr);
}
