---
title: "Bulding FPChecker"
keywords: sample homepage
layout: page
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: installation.html
summary: These brief instructions will help you get started to install FPChecker.
---

## Requirements
- A Linux system is required to run FPChecker. Support for macOS is coming soon.
- FPChecker is developed as an extension of the clang/LLVM compiler. To build FPChecker, one of the following versions of clang/LLVM must be already installed:
  - clang/LLVM 12.0
  - clang/LLVM 13.0 (will be supported soon)
- Python 3
- To run the tests, pytest (see [here](https://docs.pytest.org/en/6.2.x/)) is needed.

## Source Code
The source is available at github: [https://github.com/LLNL/FPChecker](https://github.com/LLNL/FPChecker)

Checkout FPChecker:

```
$ git clone https://github.com/LLNL/FPChecker.git
```

## Building
FPChecker can be built using a recent version of `cmake`. Support to build via Spack is coming soon.

```
$ mkdir build
$ cd build
$ cmake -DCMAKE_INSTALL_PREFIX=/path/to/install .. 
$ make && make install
```

{% include note.html content="Note that cmake will attempt to search for `clang++` and `llvm-config` in your environment. So make sure these commands are visible in the environment before building." %}

## Testing

To run the tests, use `ctest` in the build directory:

```
$ ctest -V
```

