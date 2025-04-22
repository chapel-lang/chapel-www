proc runEulerMethod(step: real, count: int, t0: real, y0: real) {
    var y = y0;
    var t = t0;
    for i in 1..count {
        y += step*f(t,y);
        t += step;
    }
    return y;
}

record empty {}
record cons {
    param head: real;
    type tail;
}

proc length(type x: cons(?w, ?t)) param do
  return 1 + length(t);

proc length(type x: empty) param do
  return 0;

proc coeff(param x: int, type ct: cons(?w, ?t)) param {
    if x == 1 {
        return w;
    } else {
        return coeff(x-1, t);
    }
}

proc runMethod(type method, step: real, count: int, start: real,
               in n: real ... length(method)): real {

    param coeffCount = length(method);
    // Repeat the methods as many times as requested
    for i in 1..count {
        // We're computing by adding h*b_j*f(...) to y_n.
        // Set total to y_n.
        var total = n(coeffCount - 1);
        // 'for param' loops are unrolled at compile-time -- this is just
        // like writing out each iteration by hand.
        for param j in 1..coeffCount do
            // For each coefficient b_j given by coeff(j, method),
            // increment the total by h*bj*f(...)
            total += step * coeff(j, method) *
                f(start + step*(i-1+coeffCount-j), n(coeffCount-j));
        // Shift each y_i over by one, and set y_{n+s} to the
        // newly computed total.
        for param j in 0..< coeffCount - 1 do
            n(j) = n(j+1);
        n(coeffCount - 1) = total;
    }
    // return final y_{n+s}
    return n(coeffCount - 1);
}

proc f(t: real, y: real) do
  return y;

type euler = cons(1.0, empty);
type adamsBashforth = cons(3.0/2.0, cons(-0.5, empty));
type someThirdMethod = cons(23.0/12.0, cons(-16.0/12.0, cons(5.0/12.0, empty)));

writeln(runMethod(euler, step=0.5, count=4, start=0, 1));

writeln(runMethod(adamsBashforth, step=0.5, count=3, start=0, 1,
    runMethod(euler, step=0.5, count=1, start=0, 1)));
