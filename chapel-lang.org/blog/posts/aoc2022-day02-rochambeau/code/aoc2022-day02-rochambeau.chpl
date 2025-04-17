use IO;
use outcome, shape;

enum outcome {lose=0, draw=3, win=6};
enum shape {rock=1, paper, scissors};
enum entry {A=rock:int, B, C,
            X=rock:int, Y, Z};

proc beats(s1, s2) {
  return s1 == rock && s2 == scissors ||
         s1 == paper && s2 == rock ||
         s1 == scissors && s2 == paper;
}

proc verdict(abc, xyz) {
  const them = abc: int: shape,
        us   = xyz: int: shape;

  if them == us {
    return draw;
  } else if beats(them, us) {
    return lose;
  } else if beats(us, them) {
    return win;
  } else {
    halt("We should never get here: ", (them, us));
  }
}

proc score((abc, xyz)) {
  return xyz:int + verdict(abc, xyz):int;
}

iter readGuide() {
  var abc, xyz: string;

  while readf("%s %s", abc, xyz) do
    yield (abc:entry, xyz:entry);
}

const Guide = readGuide();

writeln(+ reduce score(Guide));
