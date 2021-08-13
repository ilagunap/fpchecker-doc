---
title: "How to Use FPChecker"
keywords: sample homepage
layout: page
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: how-to-use.html
summary: These brief instructions will help you get started to use FPChecker in your application.
---

FPChecker instruments applications at compile time. There are two ways to instrument code: **semi-automatic** mode or **automatic** mode (see below).

## Compiling C/C++
### Semi-automatic Mode
FPChecker provides the following wrapper scripts for C/C++ and MPI:

| Original Compiler | Wrapper | Purpose |
|-------|--------|---------|
| clang | clang-fpchecker | To compile C code |
| clang++ | clang++-fpchecker | To compile C++ code |
| mpicc | mpicc-fpchecker | To compile MPI C code |
| mpicxx, mpic++ | mpicxx-fpchecker, mpic++-fpchecker | To compile MPI C++ code |

Simply modify the build scripts (e.g., Makefile) of the application to use the above wrappers instead of the original compiler. If the application uses cmake, one could run, for example:
```
$ CXX=clang++-fpchecker cmake
```
To instrument the code at build time, the `FPC_INSTRUMENT` environment variable must be set; this can be set when running make:
```
$ FPC_INSTRUMENT=1 make -j
```
If `FPC_INSTRUMENT` is not set, the application will be compiled without instrumentation, and no events will be detected.

#### MPI and OpenMP
The MPI wrappers use the MPI compilers (`mpicc`, `mpicxx`, or `mpic++`) available in the environment. Therefore, an MPI implementation must be installed in the system to compile MPI code. FPChecker supports (Open MPI)[https://www.open-mpi.org/]; support for MPICH is coming soon. To compile OpenMP code, provide the `-fopenmp` flag at compile time.

### Automatic Mode
Alternatively, instead of modifying the application build scripts, FPChecker can automatically intercept the original compiler commands and replace them with the appropriate wrappers. Just run `fpchecker` and provide the build command as input:
```
$ fpchecker make -j
```
This mode doesn’t require setting `FPC_INSTRUMENT` (it does it automatically).

## Compiling CUDA
To compile CUDA, FPChecker uses a simple front-end that instruments arithmetic operations (e.g., x = a + b …) with no dependencies on clang/LLVM. While this version is a work in progress, it can instrument most CUDA kernels.

The CUDA checking component only detects the most critical events: infinity (+), infinity (-), NaN, and division by zero.

Replace `nvcc` in your build system with `nvcc-fpchecker` (the nvcc wrapper). For `cmake`, one can use `cmake -DCMAKE_CUDA_COMPILER=nvcc-fpchecker`, for example. To instrument the code at build time, the `FPC_INSTRUMENT` environment variable must be set:
```
$ FPC_INSTRUMENT=1 make -j
```
### Automatic Mode
Alternatively, FPChecker can automatically intercept the original compiler commands and replace them with the nvcc wrapper:
```
$ fpchecker make -j
```

## Running the Instrumented Application
After compiling and instrumenting, the application can be run normally:
```
$ ./application input
#FPCHECKER: Initializing...
...
...
...
#FPCHECKER: Finalizing and writing traces...
```
FPChecker will indicate that it is being initialized when the application begins execution. It will also indicate that it is being finalized and traces are being written when the application ends. The traces will be saved in the directory where the application is run in the `.fpc_logs` subdirectory.

## Report

To generate the FPChecker report, see [here](reports.html).
