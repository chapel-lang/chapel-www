  union u {
    var w: int;
    var x: int;
    var y: real;
    var z: string;
  }

  var u0 = new u(),
      uw = new u(w=78),
      ux = new u(x=45),
      uy = new u(y=33.3),
      uz = new u(z="hi");

  writeln((u0, uw, ux, uy, uz));

  var ureal = new u(33.3333),
      ustring = new u("hello");

  writeln((ureal, ustring));

  proc ref u.double() {
    union select this {
      when w do w *= 2;
      when x do x *= 2;
      when y do y *= 2.0;
      when z do z += z;
      otherwise {
        const fieldID = this.getActiveIndex();
        if fieldID != -1 then
          halt("unexpected active field in 'u.double()': ", fieldID);
      }
    }
  }

  u0.double();
  uw.double();
  ux.double();
  uy.double();
  uz.double();

  writeln((u0, uw, ux, uy, uz));
