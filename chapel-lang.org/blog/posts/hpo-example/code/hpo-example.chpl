use Random, List, Subprocess, OS.POSIX, BlockDist;

proc evaluate(targetProgram: string, const ref combosToCheck: [] combo) {

  forall currentCombo in combosToCheck { 

    var programCall = targetProgram;

    // Build the command-line call we should make
    for (arg, val) in currentCombo.args {
      programCall += " --" + arg + "=" + val: string;
    }

    var process = spawnshell(programCall, stdout=pipeStyle.pipe, 
                             stderr=pipeStyle.pipe);

    while process.running {
      currentTask.yieldExecution();
      process.poll();
    }

    process.communicate();
    try {
      currentCombo.result = process.stdout.read(real);
    } catch e {
      writeln("run failed: ", e.message());
      currentCombo.result = max(real);
    }
  }
}

config const numTrials = 10,
             seed = 121242412,
             targetProgram = "python3 toy.py",
             argsString = "('x', (0, 30))";

record combo {
  var args: list((string, int));
  var result: real;
}

proc main() {
  var args = parseArgSpace(argsString);
  var target = targetProgram.strip("\"");

  const BlockSpace = blockDist.createDomain({0..<numTrials});
  var combosToCheck: [BlockSpace] combo;

  randomSampling(args, combosToCheck);

  evaluate(target, combosToCheck);

  var result = findBest(combosToCheck);

  // These five lines are useful output for the user for debugging, but might
  // want to comment out for production runs with a lot of trials.
  writeln("Target program was: ", target);
  writeln("Combos checked were:");
  for currentCombo in combosToCheck {
    writeln(currentCombo);
  }

  writeln("Best found was:");
  writeln(result);
}

proc parseArgSpace(argsString: string): list((string, (int, int))) {
  var args = new list((string, (int, int)));
  var argGroups = argsString.split(";");
  for arg in argGroups {
    arg = arg.strip()[1..arg.size-2];
    const argParts = arg.split(",");
    const argName = argParts[0].strip(" \t\r\n("),
          argRangeLow = argParts[1].strip(),
          argRangeHigh = argParts[2].strip(" \t\r\n)");
    const low = argRangeLow[1..].strip(): int,
          high = argRangeHigh[0..argRangeHigh.size-1].strip(): int;
    args.pushBack((argName, (low, high)));
  }
  return args;
}

private var rng = new randomStream(int, seed);

proc randomSampling(optimizableArgs: list((string, (int, int))),
                    ref combosToCheck: [] combo) {

  // Determine the values to try for the arguments
  for currentCombo in combosToCheck {
    // Based on the limits provided in the argument list, determine a
    // value to try for this particular tuning trial
    for (name, (low, high)) in optimizableArgs {
      var val = rng.next(low, high);
      currentCombo.args.pushBack((name, val));
    }

  }
}

proc findBest(const ref combosToCheck: [] combo) {
  const (bestVal, bestIndex) = minloc reduce zip (combosToCheck.result,
                                                  combosToCheck.indices);

  // Return the argument/hyperparameter settings that led to that lowest value
  return combosToCheck[bestIndex].args;
}
