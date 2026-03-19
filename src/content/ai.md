+++
title = "Chapel and AI"
description = "Examples of Chapel's use in AI and ML"

+++

### Doing AI in Chapel

As a general-purpose, scalable parallel programming language, Chapel
is well-suited for computations in Artificial Intelligence and Machine
Learning.  In practice, Chapel can either be used as a scalable driver
of existing, highly tuned library routines for AI/ML, or to write
novel distributed algorithms that do not yet have a vendor-tuned
library solution.  Moreover, due to its portable design and
implementation, Chapel avoids lock-in to any single hardware vendor.

Some past examples of using Chapel for AI/ML-related workloads include:

* CrayAI's [HyperParameter Optimization (HPO)
  module](https://cray.github.io/crayai/hpo/hpo.html), which is
  described in [this SC20 tutorial
  talk](https://www.youtube.com/watch?v=9FjDfkhF6tE) and was recently
  revisited in [this blog
  article](https://chapel-lang.org/blog/posts/hpo-example/)


* Student projects exploring the use of Chapel to express tensors and
  transformers, or to drive PyTorch, including:

  - the [ChAI project](https://github.com/Iainmon/ChAI#readme),
    developed by interns and students from Oregon State
    University—[this ChapelCon '25
    talk](https://chapel-lang.org/chapelcon25/#chai) serves as a good
    introduction

  - a project by a University of Tokyo summer student that compared
    hand-written [transformers in
    Chapel](https://chapel-lang.org/blog/series/transformers-from-scratch-in-chapel-and-c++/)
    against C++ and Pytorch

In addition to the above, there are ongoing explorations of Chapel's
use in AI that are not yet publicly documented.


### Writing Chapel with AI

Beyond using Chapel to write AI computations, developers have also
explored the use of AI to generate Chapel programs.  As an example,
see [_Experimenting with the Model Context Protocol and
Chapel_](https://chapel-lang.org/blog/posts/claude-mcp/) on the Chapel
blog for one developer's experiences using Claude to write Chapel
programs.
