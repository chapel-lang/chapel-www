use IO, Map, List;

class Dir {
  var name: string;

  var files = new map(string, int);
  var dirs = new list(owned Dir);

  proc type fromInput(name: string): owned Dir {
    var line: string;
    var newDir = new Dir(name);

    while readLine(line, stripNewline = true) {

      if line == "$ cd .." {
        break;

      } else if line.startsWith("$ cd ") {
        param cdPrefix = "$ cd ";
        const dirName = line[cdPrefix.size..];
        newDir.dirs.pushBack(Dir.fromInput(dirName));

      } else if !line.startsWith("$ ls") && !line.startsWith("dir") {
        const (size, _, name) = line.partition(" ");
        newDir.files[name] = size : int;

      }
    }
    return newDir;
  }

  iter dirSizes(ref parentSize = 0): int {
    // Compute sizes from files only.
    var size = + reduce files.values();
    for subDir in dirs {
      // Yield directory sizes from the dir.
      for subSize in subDir.dirSizes(size) do yield subSize;
    }
    yield size;
    parentSize += size;
  }

}

var rootFolder = Dir.fromInput("/");

var rootSize = 0;
writeln(+ reduce [size in rootFolder.dirSizes(rootSize)] if size < 100000 then size);

const toDelete = rootSize - 40000000; // = 30000000 - (70000000 - rootSize)

writeln(min reduce [size in rootFolder.dirSizes()] if size >= toDelete then size);
