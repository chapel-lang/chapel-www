config const n = 1_000_000,
             alpha = 0.01;

coforall loc in Locales {
  on loc {
    cobegin {
      // have one task explicitly spawn off a Triad task per GPU
      coforall gpu in here.gpus do on gpu {
        var A, B, C: [1..n] real;
        A = B + alpha * C;
      }

      // have the other use data parallelism to target all CPU cores
      {
        var A, B, C: [1..n] real;
        A = B + alpha * C;
      }
    }
  }
}
