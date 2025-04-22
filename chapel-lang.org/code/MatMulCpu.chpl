config const N = 2000, M = 3000, P = 4000;

var A: [1..N,1..M] real = 1.0;
var B: [1..M,1..P] real = 1.0;
var C: [1..N,1..P] real = 1.0;

forall (i,k) in C.domain {
  for j in 1..M {
    C[i,k] += A[i,j] * B[j,k];
  }
}







