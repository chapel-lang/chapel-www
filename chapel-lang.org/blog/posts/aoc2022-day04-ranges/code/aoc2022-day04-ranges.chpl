  use IO;
  // Chapel iterator that reads in all lines from standard input
  // and yields 2-tuples of ranges.
  // Assumes that all lines are in the format "%i-%i,%i-%i".
  iter readSections() {
    var s1, e1, s2, e2: int;
    while readf("%i-%i,%i-%i", s1, e1, s2, e2) {
      yield (s1..e1, s2..e2);
    }
  }
  // Creates an array with all elements yielded
  // by the `readSections` iterator.
  var sections = readSections();

  // Parallel reduction to add up the number of subsets and the number of overlaps.
  var sumSubset = 0;
  var sumOverlap = 0;
  forall (r1,r2) in sections with (+ reduce sumSubset, + reduce sumOverlap) {
    sumSubset += r1.contains(r2) || r2.contains(r1);
    const intersection = r1[r2];
    sumOverlap += intersection.size > 0;
  }

  writeln("sumSubset = ", sumSubset);
  writeln("sumOverlap = ", sumOverlap);
