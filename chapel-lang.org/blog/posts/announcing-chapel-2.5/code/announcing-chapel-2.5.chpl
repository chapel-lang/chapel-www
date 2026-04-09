var A = [1, 2, 3, 4],
    B2D = reshape(A, {1..2, 1..2});

B2D[1, 1] = 5;

ref A2D = reshape(A, {1..2, 1..2});
A2D[1, 2] = 6;

writeln(A);  // prints '1 6 3 4'
