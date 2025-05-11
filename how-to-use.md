---
title: "How to Use FPChecker"
keywords: sample homepage
layout: page
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: how-to-use.html
summary: These brief instructions will help you get started to use FPChecker in your application.
---

FPChecker works by instrumenting applications at compile time. There are three ways to instrument applications:

- (1) Makefile interceptor (automatic mode)
- (2) Clang wrappers (semi-automatic mode)
- (3) Adding compilation flags (manual mode)

The automatic mode is the easiest to use, but it only works in Linux using the `LD_PRELOAD` trick (assuming the system allows it fully). The semi-automatic mode works in most cases but can have issues with some build systems. The manual mode works in all cases but requires more changes to the application build scripts.

## Makefile Interceptor (Automatic mode)


To instrument the code, one must modify the build scripts to allow LLVM load the appropriate plug-in library. However, instead of modifying the application build scripts, FPChecker can automatically intercept the original compiler commands and will add the required flags. Just run `fpchecker` and provide the `make` build command as input:
```
$ fpchecker make -j
```
In this mode, the `fpchecker` interceptor, will use the `LD_PRELOAD` trick in Linux to intercept all the `clang` and `clang++` commands and add the required flags. This only works in Linux (not supported in MacOS).


## Clang wrappers (Semi-automatic mode)

In this mode, the `clang` and `clang++` compilers must be replaced by the `clang-fpchecker` and `clang++-fpchecker` wrappers, respectively. FPChecker provides the following wrapper scripts for C/C++ and MPI:

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

### MPI and OpenMP
The MPI wrappers use the MPI compilers (`mpicc`, `mpicxx`, or `mpic++`) available in the environment. Therefore, an MPI implementation must be installed in the system to compile MPI code. FPChecker supports (Open MPI)[https://www.open-mpi.org/]; support for MPICH is coming soon. To compile OpenMP code, provide the `-fopenmp` flag at compile time.

##  Adding compilation flags (Manual mode)

The third method to instrument the code is to add the following compilation flags to CFLAGS and or CXXFLAGS:

- "-g"
- "-include /path/to/install/src/Runtime_cpu.h"
- "-fpass-plugin=/path/to/install/lib/libfpchecker_cpu.so"

The first one allows compilations with debug information; the second pre-included the runtime system; the third load the plug-in library.

Running the `fpchecker-show` command shows the location af these files and the flags to add:

```
$ fpchecker-show
========================================
         FPChecker Configuration        
========================================

Installation path: /tmp/tutorial/FPChecker/build/install

Add this to CFLAGS and/or CXXFLAGS:
-g -include /tmp/tutorial/FPChecker/build/install/src/Runtime_cpu.h -fpass-plugin=/tmp/tutorial/FPChecker/build/install/lib/libfpchecker_cpu.so

Wrappers are located here:
/tmp/tutorial/FPChecker/build/install/bin/clang-fpchecker
/tmp/tutorial/FPChecker/build/install/bin/clang++-fpchecker
/tmp/tutorial/FPChecker/build/install/bin/mpicc-fpchecker
/tmp/tutorial/FPChecker/build/install/bin/mpicxx-fpchecker
```

In this mode, the original `clang` and `clang++` compilers must be used (not the wrappers). The `FPC_INSTRUMENT` environment variable must be set.


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
