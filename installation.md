---
title: "Bulding FPChecker with CMake"
keywords: sample homepage
layout: page
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: installation.html
summary: These brief instructions will help you get started to install FPChecker.
---

## Requirements
- Operating systems: Linux or MacOS (not all features supported in MacOS).
- Cmake (a recent version)
- FPChecker is developed as an extension of the clang/LLVM compiler. Currently, the clang/LLVM version that is supported is 19.1.7.
- Python 3 with:  matplotlib, colorama/termcolor (for terminal output color).
- Pytest (optional) to run the tests (see [here](https://docs.pytest.org/)).

## Source Code
The source is available at github: [https://github.com/LLNL/FPChecker](https://github.com/LLNL/FPChecker)

Checkout FPChecker:

```
$ git clone https://github.com/LLNL/FPChecker.git
```

## Setting up Clang/LLVM

Clang and LLVM can be obtained and set up on your system through two primary methods: building from source or installing pre-built packages. To build it from source, see [https://llvm.org/docs/GettingStarted.html](https://llvm.org/docs/GettingStarted.html).

Installing pre-built packages is the simplest and most common way to get Clang and LLVM. In Ubuntu, one case use `apt`. 

Another practical way to install it is using Conda environments:

```
$ conda install llvmdev=19.1.7 -c conda-forge
$ conda install clangxx=19.1.7 -c conda-forge
```


## Checking Prerequisites
Before building, check that the supported version of clang++ is in your path:

```
$ clang++ --version
clang version 19.1.7
...
```

Check that the `llvm-config` command is in your path:
```
$ llvm-config --version
19.1.7
```

## Building
FPChecker can be built using a recent version of `cmake`.

```
$ mkdir build
$ cd build
$ cmake -DCMAKE_INSTALL_PREFIX=/path/to/install .. 
$ make && make install
```

{% include note.html content="Note that cmake will attempt to search for `clang++` and `llvm-config` in your path. So make sure these commands are visible in the environment before building." %}

## Testing

To run the tests, use `ctest` in the build directory:

```
$ ctest -V
```

