use Python;

var interp = new Interpreter(),
    torch = new Module(interp, "torch"),
    tensor = new Function(torch, "tensor");

var T = tensor(owned Value, [[1.0,2.0], [3.0,4.0]]);
writeln(T.str());

config const func = "lambda x,: x";

var myFunc = new Function(interp, func);

var A: [1..10] int = 1..10;

writeln("Before: ", A);

for a in A do
  a = myFunc(int, a);

writeln("After: ", A);

 use CompressedSparseLayout;

 config const n = 9;

 // declare a dense domain of size n x n, as well as a sparse subdomain
 // storing just the main diagonal in CSR format
 const D = {1..n, 1..n},
       Diag: sparse subdomain(D) dmapped new csrLayout() = [i in 1..n] (i,i);

 // declare an array over that domain, storing a real value per non-zero
 var Mat: [Diag] real;

 // initialize each non-zero element with a unique value
 forall (i,j) in Diag do
   Mat[i,j] = i + j/10.0;

 // print the sparse array as though it was dense
 for (i,j) in D do
   write(Mat[i,j], if j == n then "\n" else " ");

 // move this task to another locale
 on Locales.last {
   // make a local copy of the sparse array
   var LocMat = Mat;

   // double its values
   LocMat *= 2;

   // iterate over the non-zeroes, printing them out
   for r in LocMat.rows() do
     for (c, m) in LocMat.colsAndVals(r) do
       writeln("Mat", (r,c), " = ", m);
 }
