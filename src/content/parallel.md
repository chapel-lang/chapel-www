+++
title = "Chapel: Built for Parallelism"
description = "Parallel computing with the Chapel programming language"
keywords = ["TODO"]

[[parallelFeatures]]
  name = "Task Parallelism"
  description="Launch new tasks with Chapel's `begin`, `cobegin`, and `coforall` constructs."
  url="https://chapel-lang.org/docs/primers/taskParallel.html"

[[parallelFeatures]]
  name="Data Parallelism"
  description="Parallelize computation over large datasets with parallel arrays, scalar promotion and `forall` loops."
  url="https://chapel-lang.org/docs/primers/#data-parallelism"

[[parallelFeatures]]
  name="Atomics"
  description="Chapel's native `atomic` and `sync` types provide a hardware-supported way to coordinate tasks."
  url="https://chapel-lang.org/docs/primers/atomics.html"

[[parallelFeatures]]
  name="Locales"
  description="First-class concepts for enumerating and reasoning about machine resources."

[[parallelFeatures]]
  name="On clauses"
  description="Coordinate multi-node execution without mangling your program with Chapel's `on` statements."
  url="https://chapel-lang.org/docs/primers/locales.html"

 
[[parallelFeatures]]
  name="Distributed Domains and Arrays"
  description="Automatically distribute data across multiple nodes with Chapel's built-in data distributions."


[[parallelismTypes]]
  name="Shared-Memory Parallelism"
  description="Effortlessly leverage your multi-core CPUs for task and data parallelism."


[[parallelismTypes]]
  name="CPU and GPU Parallelism"
  description="Update a handful of lines of code and your application can be ready for GPU execution."
  url="/gpu"

[[parallelismTypes]]
  name="Distributed-Memory Parallelism"
  description="Chapel's global namespace makes distributed-memory parallelism as easy as writing code for your laptop."


+++



# Parallelism at Any Scale

Chapel is built from the ground up with productive and performant parallel computing in mind. Conventionally, leveraging parallelism at different scales requires different programming models with different features, syntax, and interfaces. Chapel programs can leverage multiple types of parallelism with a single unified set of language features:
{.content-paragraph}

{{<grid "parallelismTypes">}}

# Parallel Programming Features that Fit Together

Conventional distributed programming requires users to write their code in terms of individual processes, manually coordinating all communication between each node. Distributed programming doesn't have to be this way, and Chapel's global namespace is the perfect alternative. You can compute on distributed data structures with the same code you would use for a completely local version. __Keep the performance of distributed parallelism, lose the finicky sends and receives. Or don't!__ If you need, you can distribute data and coordinate message passing manually, or mix manual control with global-view programming. The beauty of Chapel is that you can choose the level(s) of abstraction best fit for your project.
{.content-paragraph}

{{<grid "parallelFeatures">}}

