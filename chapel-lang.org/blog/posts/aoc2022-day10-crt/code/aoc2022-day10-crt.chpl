use IO;

iter ops() {
  yield 1; // Initial state
  for line in stdin.lines().strip() {
    select line[0..3] {
      when "noop" do yield 0;
      when "addx" {
        yield 0;
        yield line[5..] : int;
      }
    }
  }
}

const deltas = ops(),
      cycles = deltas.size,
      Xs: [1..cycles] int = + scan deltas,

      interesting = 20..220 by 40;

writeln(+ reduce (Xs[interesting] * interesting));

config const crtRows = 6,
             crtCols = 40;

const Screen = {0..<crtRows, 0..<crtCols};

const spritePos = reshape(Xs[1..Screen.size], Screen);

const pixels = [(row, col) in Screen]
  if abs(col - spritePos[row, col]) <= 1 then "#" else ".";
writeln(pixels);
