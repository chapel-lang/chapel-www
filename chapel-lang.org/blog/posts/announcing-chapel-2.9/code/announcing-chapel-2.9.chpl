  union u {
    var x: int;
    var y: int;
    var z: real;
  }

  config const testErrors = false;

  var myU, myU2: u;
  myU.y = 45;
  writeln(myU.y);    // prints '45'
  if testErrors {
    writeln(myU.x);  // error: halt reached - illegal union access: attempted
                     // to access field 'x' but 'y' is currently active
    writeln(myU.z);  // error: halt reached - illegal union access: attempted
                     // to access field 'z' but 'y' is currently active
  }

  writeln("myU is: ", myU);

  writeln("The active field is #", myU.getActiveIndex());

    const fieldIdx = myU.getActiveIndex();
    if  fieldIdx == 0 then
      writeln("x is active: ", myU.x);
    else if fieldIdx == 1 then
      writeln("y is active: ", myU.y);
    else if fieldIdx == 2 then
      writeln("z is active: ", myU.z);
    else
      halt("got an unexpected index");

  myU.visit(proc(x: int)  { writeln("x is ", x); },
            proc(y: int)  { writeln("y is ", y); },
            proc(z: real) { writeln("z is ", z); });

  myU.visit(foo, bar, baz);

  proc foo(x: int) { writeln("In foo, x is: ", x); }
  proc bar(y: int) { writeln("In bar, y is: ", y); }
  proc baz(z: real) { writeln("In baz, z is: ", z); }

  myU2.y = 78;
  writeln(myU == myU2);  // false, since the active fields aren't equal
  myU2.y = 45;
  writeln(myU == myU2);  // true, since the same fields are active and equal
  myU2.x = 45;
  writeln(myU == myU2);  // false, since different fields are active
  writeln(myU != myU2);  // true, since different fields are active

  {  // open a new scope to limit these overloads to the code within
    operator u.==(a: u, b: u) {
      const aIdx = a.getActiveIndex(),
            bIdx = b.getActiveIndex();

      if aIdx == 0 && bIdx == 1 {
        return a.x == b.y;
      } else if aIdx == 1 && bIdx == 0 {
        return a.y == b.x;
      }
      return false;
    }

    operator u.!=(a: u, b: u) {
      return !(a == b);
    }

    writeln("Using my overload, ", myU, " == ", myU2, " => ", myU == myU2);
    writeln("Using my overload, ", myU, " != ", myU2, " => ", myU != myU2);
  }
