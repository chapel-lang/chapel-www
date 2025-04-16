+++
title = "Accelerate Development with a Productive Language"
description = "Productive Computing with the Chapel programming language"
keywords = ["TODO"]


[[languageFeatures]]
  name = "Config Declarations"
  description="Language-level support for overriding default values from the command-line, at both compile-time and run-time."
  url="https://ato.pxeger.com/run?1=PZAxbsMwDEV3nYIREKAuqgzpEtjQLboVHRSXsgVIsiHJqX2WLl3S-3T0bUrHsieC_MR_-P_7t25Vj3aGdy6iH9yncVG-8heg1U1vU48yoLL84-c-JC0u81_deW0aoBET3DBcu4ggQSsbsWJZvakADmNUzaLxFq3t-K72KigHmUb6eVcSAWHl0r3uXG9xrBgzekelFj0D-AomofVPmVLQ0wIdy833ebWp2PY5UqgSKNp4WjBlTMH4pqjWYFu-IxUhsqlszaQOjzJExssUBtzb-Ac"
[[languageFeatures]]
  name = "Interoperability"
  description="Chapel is designed to interoperate seamlessly with libraries written in C. No need to rewrite important libraries."
  url="https://chapel-lang.org/docs/technotes/extern.html"
[[languageFeatures]]
  name = "Memory Safety"
  description = "Scope-based (de)allocation, ownership management, default-safe strings, and other semantic checks make Chapel safer than C and C++."

[[highlightGrid]]
  name="Easy and Fast Ramp Up"
  description="Chapel enables users to bring new contributors up to speed in record time."
  url="/blog/posts/7qs-laurendeau/"
[[highlightGrid]]
  name="""
  Writes Faster,  
  Runs Faster
  """
  description="Peer-reviewed studies show that Chapel is faster and more productive than alternatives."
  url= "https://link.springer.com/chapter/10.1007/978-3-031-48803-0_11"
[[highlightGrid]]
  name="Language Tooling Support"
  description="The Chapel language server and linter integrate with your favorite editor to supercharge your development experience."
  url="/blog/posts/chapel-lsp/"

[[result]]
  title="Computer Language Benchmarks Game"
  description="When compared against other common programming languages, solutions built in Chapel are both compact and performant,"
  image="/img/clbg/clbg_summary.jpg"
  url="https://www.youtube.com/watch?v=U8KM8wv32js"
  weight=2

[[result]]
  title="Computer Language Benchmarks Game"
  description="When compared against other common programming languages, solutions built in Chapel are both compact and performant.<br> (swipe to zoom in on the fastest languages)"
  image="/img/clbg/clbg_summary-zoomed-out.jpg"
  url="https://www.youtube.com/watch?v=U8KM8wv32js"
  weight=1

[[result]]
  title="Parallel Metaheuristics"
  description="Chapel implementations of parallel metaheuristic algorithms are more productive than Julia, Python, and OpenMP reference implementations"
  image="/img/RelativeProductivity.png"
  url="https://inria.hal.science/hal-02879767"
  source="Source: Gyms et al. A comparative study of high-productivity high-performance programming languages for parallel metaheuristics. Swarm and Evolutionary Computation, 2020."
  weight=3

[[result]]
  title="Parallel Heat Equation"
  description="Chapel outperforms other modern languages in both productivity and performance."
  image="/img/heat-productivity.png"
  url="https://link.springer.com/chapter/10.1007/978-3-031-48803-0_11"
  source="Source: Diehl et al. Benchmarking the Parallel 1D Heat Equation Solver in Chapel, Charm++, C++, HPX, Go, Julia, Python, Rust, Swift, and Java. Euro-Par 2023."
  weight=2
  
[[introText]]
text="Gone are the days of a codebase where the actual purpose of your code are overshadowed by all the MPI calls required to make it work. Chapel has powerful, succinct programming constructs for targeting all kinds of parallelism at all kinds of scales. From data parallelism to task parallelism and laptop to GPU to cluster, Chapel uses a unified set of language features so you can learn them once and use them again and again."

+++


# Productivity Highlights

{{<grid "highlightGrid">}}

# Concise but Fast

{{<switcher "result">}}

# Safe and Easy Coding

{{<grid "languageFeatures">}}
