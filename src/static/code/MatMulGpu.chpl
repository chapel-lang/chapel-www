config const N = 2000, M = 3000, P = 4000;

var hostA: [1..N,1..M] real = 1.0;
var hostB: [1..M,1..P] real = 1.0;
var hostC: [1..N,1..P] real = 1.0;

on here.gpus[0] {
  var devA = hostA; // allocate on GPU
  var devB = hostB; // and copy from host to device
  var devC: hostC.type;

  forall (i,k) in devC.domain {
    for j in 1..M {
      devC[i,k] += devA[i,j] * devB[j,k];
    }
  }
  hostC = devC; // copy from device to host
}