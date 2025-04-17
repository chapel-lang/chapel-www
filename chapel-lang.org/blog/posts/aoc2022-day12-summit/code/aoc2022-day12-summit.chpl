proc readElevations() {
  use IO;

  param a = "a".toByte(),
        S = "S".toByte(),
        E = "E".toByte();

  const elevLines = stdin.lines().strip(),
        grid = {0..<elevLines.size, 0..<elevLines.first.size};

  var elevs = [(i, j) in grid] elevLines[i][j].toByte() - a;

  const (_, start) = maxloc reduce zip((elevs == (S - a)), grid),
        (_, end)   = maxloc reduce zip((elevs == (E - a)), grid);

  elevs[start] = 0;
  elevs[end] = 25;

  return (elevs: int(8), start, end);
}

proc findShortestPath(const ref elevs: [?d] int(8), start, end) {
  var minDistanceTo: [d] atomic int = max(int);
  explore(start, end, elevs, minDistanceTo, 0);
  return minDistanceTo[end].read();
}

proc explore(
  pos: 2*int,
  end: 2*int,
  const ref elevs: [?d] int(8),
  ref minTo: [d] atomic int,
  pathLen: int
) {

  // stop searching if we've reached 'end'
  if pos == end then return;

  // stop searching if another path has reached 'end' in fewer steps
  if pathLen >= minTo[end].read() then return;

  // explore the next positions in parallel
  coforall nextPos in nextPositions(pos, elevs, minTo, pathLen + 1) do
      explore(nextPos, end, elevs, minTo, pathLen + 1);
}

iter nextPositions(pos, elevs, minTo, nextPathLen) {
  // try moving in each direction
  label checkingMoves for move in ((1, 0), (-1, 0), (0, 1), (0, -1)) {
    const next = pos + move;

    // is this move on the map and valid?
    if elevs.domain.contains(next) &&
      elevs[next] - elevs[pos] <= 1 {

      // check if another path made it to 'next' in fewer steps
      //  if so, try the next direction
      //  otherwise, set minTo[next] = nextPathLen and then yield
      var minToNext = minTo[next].read();
      do {
          if nextPathLen >= minToNext then continue checkingMoves;
      } while !minTo[next].compareExchange(minToNext, nextPathLen);

      yield next;
    }
  }
}

const (elevations, start, end) = readElevations();
writeln(findShortestPath(elevations, start, end));
