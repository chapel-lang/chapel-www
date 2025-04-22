  on Locales.last var x = 42;
  writeln("I'm running on locale ", here.id,
          ", but x is stored on ", x.locale.id);

  on Locales.last {
    var x = 42;
    writeln("I'm running on locale ", here.id,
            ", and x is too (", x.locale.id,
            "), but only for this on-clause's scope");
  }
