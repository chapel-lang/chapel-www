  config const n = 10;

  var Arr2D:    [1..n, 1..n] real,   // a 2D array of reals
      ArrOfArr: [1..n] [1..n] real;  // a 1D array of 1D arrays of reals

 // Initialize the arrays using element-wise assignments
 forall i in 1..n {
   forall j in 1..n {
     const val = i + j / 10.0;

     Arr2D[i,j] = val;
     ArrOfArr[i][j] = val;
   }
 }

 // read a 2-tuple index from the console
 use IO;
 const idx = read(2*int);

 // use it to index the 2D array directly
 writeln(Arr2D[idx]);

 // index the array-of-arrays by indexing into the tuple...
 writeln(ArrOfArr[idx(0)][idx(1)]);

 // ...or by de-tupling it into distinct integers:
 const (i,j) = idx;
 writeln(ArrOfArr[i][j]);

 inspectArr(Arr2D[i, ..]);             // pass the i-th row
 inspectArr(Arr2D[.., j]);             // pass the j-th column
 inspectArr(Arr2D[n/2..#2, n/2..#2]);  // pass the central 2x2 sub-array

 inspectArr(ArrOfArr[i]);              // pass the i-th inner array
 inspectArr(ArrOfArr[i][n/2..#2]);     // pass the i-th array's center

 // print an array's values and indices
 proc inspectArr(X: [?I]) {
   writeln("Got array:");
   writeln(X);
   writeln("Declared over indices ", I, "\n");
 }

 var Arr1D = [1, 2, 3];  // declare a 1D, type-inferred array

 var ArrOfArrs = [[1, 2], [3, 4], [5, 6]];  // declare an array of arrays

 var Arr3by3 = [11, 12, 13;
                21, 22, 23;
                31, 32, 33];

 var Arr3D = [11.1, 12.1;
              21.1, 22.1;
              ;
              11.2, 12.2;
              21.2, 22.2];

 use Python;
 const interp = new Interpreter();

 // the old way of invoking 'compute_sum()'
 {
   const lib = new Module(interp, 'compute_sum_lib'),
         compute_sum = new Function(lib, 'compute_sum');

   var myArr = [i in 1..10] i,
       res = compute_sum(int, myArr);

   writeln("The sum of the numbers from 1 to 10 is ", res);
 }

 const lib = interp.importModule("compute_sum_lib",
   """
   import numpy as np
   def compute_sum(lst):
       arr = np.asarray(lst)
       return np.sum(arr)
   """.dedent());

 const compute_sum = lib.get('compute_sum');

 var myArr = [i in 1..10] i,
     res = compute_sum(int, new Array(interp, myArr));  // no copies are done!

 writeln("The sum of the numbers from 1 to 10 is ", res);

 var res2 = compute_sum(new Array(interp, myArr));

 writeln("The sum of the numbers from 1 to 10 is ", res2);

 var make_set = interp.importModule("make_set",
   """
   def make_set(*args):
       return set(args)
   """.dedent()).get('make_set');

 var s = make_set(owned PySet, 1, 2, 3);

 s.add(4);
 s.add("hello");
 s.add("world");
 writeln(s);
