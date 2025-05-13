---
title: "Code Annotations"
keywords: sample homepage
layout: page
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: annotations.html
summary: These instructions will help you to annotate code to reduce instrumnetation overhead.
---

The overhead of compiler-based instruction can be very high, particularly for code with high floating-point arithmetic intensity. We provide _annotations_ as a method to control (and hopefully reduce) the instrumentation overhead.

When a particular code region is annotated, the instrumentation only occurs in the annotated region, instead of in the entire application. We provide two levels for annotations: _function_ and _basic block_ annotations.

When code is annotated, the `FPC_ANNOTATED` variable must be set.

## Function Annotations

To annotate a function, add `FPC_INSTRUMENT_FUNC` macro to the definition of a function:

```
FPC_INSTRUMENT_FUNC
double my_function(double *x, int size) {
...
...
} 
```

## Basic Block Annotations

To annotate a basic block of code, add `FPC_INSTRUMENT_BLOCK` macro to the target basic block:

```
double my_function(double *x, int size) {
  // Annotated basic block
  FPC_INSTRUMENT_BLOCK;
  double tmp = x[0] + 1.23;
  x[1] = tmp / 2.0;
  
  // For loop
  for (int i=0; ...) {
    ...
  }
} 
```

These macros are defined in `Runtime_cpu.h` as:

```
#define FPC_INSTRUMENT_BLOCK __attribute__((annotate("_FPC_INSTRUMENT_BLOCK_"))) int _marker __attribute__((unused)) = 0;
#define FPC_INSTRUMENT_FUNC __attribute__((annotate("_FPC_INSTRUMENT_FUNCTION_")))
```
