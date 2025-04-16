+++
title = "GPU Programming Made Simple with Chapel"
description = "Writing GPU programs is a breeze with the Chapel programming language"
keywords = ["TODO"]

[[useCases]]
  name = "HPC and Scientific Computing"
  description = "Large-scale simulations, fluid dynamics, weather modeling"
  url="https://github.com/sdbachman/Chapel_Beta_Diversity"
[[useCases]]
  name = "AI and Machine Learning"
  description="Training deep neural networks and other GPU-intensive tasks"
  url="https://github.com/Iainmon/ChAI"
[[useCases]]
  name="Data Analytics and Genomics"
  description="Accelerate data processing and analysis for bioinformatics"
  url="https://github.com/femto-dev/femto/tree/main/src/ssort_chpl"

[[keyFeatures]]
  name = "Unified Syntax"
  description = "No need to write seperate code for GPUs and CPUs."
  url="/blog/posts/intro-to-gpus/"
[[keyFeatures]]
  name = "Multi-Level Abstractions"
  description="Mix high- and low-level control over execution, distribution, and data transfer."
  url="/blog/posts/gpu-data-movement/"
[[keyFeatures]]
  name="Vendor-Neutral"
  description="Run the same code on NVIDIA and AMD GPUs."
  url="https://chapel-lang.org/docs/technotes/gpu.html#vendor-portability"

[[codeExamples]]
  name = "Chapel CPU"
  codeFile = "static/code/MatMulCpu.chpl"
  lang="Chapel"
  first="true"
[[codeExamples]]
  name = "Chapel GPU"
  codeFile = "static/code/MatMulGpu.chpl"
  lang="Chapel"
  second = "true"
[[codeExamples]]
  name = "CUDA"
  codeFile = "static/code/MatMulCuda.cpp"
  lang="C++"
[[codeExamples]]
  name = "OpenCL"
  codeFile = "static/code/MatMulOpencl.cpp"
  lang="C++"


+++

GPUs are the powerhouse of modern computing systems. Chapel's general-purpose capabilities for parallelism and locality control makes GPU programming as easy as programming a multi-core CPU. These capabilities makes GPU programming intuitive on a laptop with a GPU, on a leadership-class supercomputer, or anything in between. Chapel supports programming NVIDIA and AMD GPUs in a vendor-neutral way; the same code can be used on GPUs from both vendors without any change.
{.content-paragraph}

# Example: Matrix Multiplication

{{<code-comparison "codeExamples">}}


# Key Features of Chapel for GPU Execution

{{<grid "keyFeatures">}}




