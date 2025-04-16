+++
title = "Blazing Fast Speed with Chapel"
keywords = ["TODO"]

[[singleNodeResult]]
  title="Sorting"
  description="Chapel's standard library sort runs an order of magnitude faster than that of the next fastest language."
  image="/img/perf/sort-comparison.png"
  url="/blog/posts/std-sort-performance/"
  weight=0

[[singleNodeResult]]
  title="Poisson Solver"
  description="Chapel solutions to Poisson's equation outperform C++ solutions while requiring less code overall."
  image="/img/perf/navier-stokes.png"
  url="/blog/posts/bns2/"
[[singleNodeResultNotReady]]
  name="N-Body Simulation"
  description="TODO"
  url="TODO"
  image=""
  weight=3

[[singleNodeResult]]
  title="1 Billion Row Challenge"
  description="Chapel can process massive amounts of data, all on a single multi-core machine."
  url="/blog/posts/1brc/"
  image="/img/perf/1brc-final-result.png"
  weight=1

[[singleNodeResultNotReady]]
  name="PLB2"
  description="TODO"
  url="https://github.com/attractivechaos/plb2/pull/79"
  image=""
  weight=5

[[compilerOptimizations]]
  name="Bundled Optimizations"
  description="The `--fast` flag turns on a collection of optimizations and passes optimization flags to the backend code generator for faster code every time."
  url="https://chapel-lang.org/docs/usingchapel/man.html"

[[compilerOptimizations]]
  name="Automatic aggregation"
  description="Improve communication performance with the `--auto-aggregation` flag."
  url="https://chapel-lang.org/docs/usingchapel/man.html"

[[compilerOptimizations]]
  name="Vectorization"
  description="Pass vectorization hints to the target compiler with the `--vectorize` flag."
  url="https://chapel-lang.org/docs/usingchapel/man.html"


[[fastFeatures]]
  name="Array Reductions"
  description="Sum an array or check for an element in a single parallel expression. Reductions are natively supported and automatically parallelized."
  url="https://chapel-lang.org/docs/primers/reductions.html#reductions"

[[fastFeatures]]
  name="Scalar Promotion"
  description="Scalar operations promote to accept array arguments and process in parallel."


[[fastFeatures]]
  name="Parallel IO"
  description="Use every core with built-in support for parallel file IO."
  url="https://chapel-lang.org/docs/modules/packages/ParallelIO.html"


+++

### Designed for Supercomputers, Delivers on Desktop Too

{{<switcher "singleNodeResult">}}

### Fast Out of the Box

{{<grid "fastFeatures">}}

