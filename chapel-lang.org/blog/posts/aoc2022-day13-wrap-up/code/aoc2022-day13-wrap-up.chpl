  coforall loc in Locales do
    on loc do
      coforall tid in 1..4 do
        writeln("Hello from task ", tid, " on locale ", loc.id);

  writeln("After the coforalls");
