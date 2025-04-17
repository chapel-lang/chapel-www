use IO, Set;

config const markerLen = 4;

proc uniqueChars(window) {
  var s: set(uint(8));

  for ch in window do
    s.add(ch);

  return s.size;
}

proc isMarker(window) {
  return uniqueChars(window) == markerLen;
}

var buffer: bytes;
readLine(buffer);

const inds = 0..<buffer.size-markerLen;

var (_, loc) = maxloc reduce zip([i in inds] isMarker(buffer[i..#markerLen]),
                                 inds+markerLen);

writeln(loc);
