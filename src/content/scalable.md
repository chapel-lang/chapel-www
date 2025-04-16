+++
title = "Scaling your Workflows with Chapel"
description = "Scalability results with the Chapel programming language"
keywords = ["TODO"]

[[reasons]]
  name = "Global View of Data"
  description="Chapel has built-in support for distributed global arrays, meaning computations written for a single node can run on an entire cluster."
[[reasons]]
  name = "Multi-level Parallelism"
  description="The same language features support parallelism at the node and cluster level. Parallelize once and reap the benefits everywhere."
  url="https://chapel-lang.org/docs/users-guide/locality/compilingAndExecutingMultiLocalePrograms.html"
  
[[reasons]]
  name = "Data and Computational Locality"
  description="Control where your program's tasks are executed using Chapel's extensive locality features."
  url="https://chapel-lang.org/docs/primers/locales.html"

[[perfResults]]
  title="Arkouda Argsort"
  description="Arkouda's argsort routine can sort 256 TiB of data in just 31 seconds, scaling to more than 8,000 nodes. All in ~100 lines of Chapel code."
  image="img/perf/arkouda-argsort.png"
  weight = 1
  url="https://youtu.be/SuZckfFF_pE?si=jCEHkxaLt5k6q8ec&t=1008"
[[perfResults]]
  title = "Navier-Stokes Simulations"
  description = "Solve Navier-Stokes equations in Chapel, achieving comparable performance to C++ and MPI with half the code and improved clarity and flexibility."
  image = "img/perf/navier-stokes-dist.png"
  weight=5
  url="/blog/posts/bns4/"
[[perfResults]]
  title = "Bale Index Gather"
  description = "Gather arbitrary elements from distributed arrays or tables in an aggregated manner to scale to thousands of nodes and hundreds of thousands of processor cores."
  image = "img/perf/baleIG.jpg"
  weight=7
  url="https://youtu.be/ydsM51T7Pts?si=Ahtu-Aq1UH_iOiBm"
[[perfResults]]
  title = "NAS FT"
  description = "Computes the FFT of a distributed 3D array by computing 1D FFTs and transposing to localize other dimensions."
  image = "img/perf/perf-ft.png"
  weight = 19
  url = "https://www.nas.nasa.gov/software/npb.html"
[[perfResults]]
  title = "STREAM Triad"
  description = "The de facto industry standard benchmark for measuring memory performance."
  image = "img/perf/perf-stream.png"
  weight=10
  url="https://hpcchallenge.org/hpcc/"
[[perfResults]]
  title = "PRK Stencil"
  description="Measures the performance of applying a radius-2 star stencil to a distributed 2D array. Emphasizes the performance of nearest-neighbor communication."
  image = "img/perf/perf-stencil.png"
  weight=20
  url="https://github.com/ParRes/Kernels/tree/main#readme"
[[perfResults]]
  title = "HPCC Random Access"
  description="Measures the performance of concurrent random updates to a distributed array."
  image = "img/perf/perf-random-access.png"
  weight = 12
  url = "https://hpcchallenge.org/projectsfiles/hpcc/RandomAccess.html"

#[[perfResults]]
#  title="GPU Scaling"
#  description=""


+++

Workflows written using Chapel scale enormously. The same code written on your laptop can perform on however many nodes you can give it, be it one, dozens, or thousands. Applications written by Chapel users have successfully scaled to more than 8,000 compute nodes, 1,000,000 CPU cores, and 1,000 GPUs. The largest supercomputers in the world run Chapel. No matter the scale of your system, you can scale too.
{.content-paragraph}

# Scaling Results with Chapel

{{<switcher "perfResults">}}

# Why Chapel Makes Scaling Easier

{{<grid "reasons">}}
