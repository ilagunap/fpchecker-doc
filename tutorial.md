---
title: "Tutorial"
keywords: sample homepage
layout: page
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: annotations.html
summary: Details of the FPChecker tutorial
---

<p align="center">  <img src="./images/fpchecker/logo.jpg" width="300"> </p>

# FPChecker Tutorial:  Understand the Floating-Point Arithmetic Behavior of Your Code

Ever wondered why 0.1 + 0.2 doesn’t always equal 0.3 in your code? Frustrated by “Not a number” (NaN) errors creeping into your calculations? You are not alone. Floating-point arithmetic is fundamental in computing, yet it’s a common source of confusion and bugs for developers working with numerical software.

This tutorial presents [FPChecker](https://fpchecker.org/index.html), a tool that helps developers gain a better picture of what's happening in terms of floating-point arithmetic in their applications. FPChecker allows you to detect hidden exceptions (e.g., division by zero), cancellation, and other errors in C/C++ programs using the clang/LLVM compiler. It can analyze parallel HPC applications using MPI and OpenMP.

What you’ll learn in the tutorial:

* The installation and usage process of FPChecker
* How to identify the location of floating-point exceptions and other errors
* When and why computations get out of range for a given precision level
* Strategies to numerically profile mixed-precision (FP32 and FP64) software
* Strategies to control the runtime overhead when using the tool

The tutorial uses simple examples to showcase the tool's functionality, including examples of linear solvers, finite differences, and finite elements methods applied to simple 2D PDEs using C/C++. 

### Required Knowledge & Software
The only prerequisite for this tutorial is the ability to compile C/C++ software with the clang/LLVM compiler (e.g., using Makefiles).

The tutorial uses Conda environments to build the tool and to run the examples on the participants' laptops. To be able to run the examples, participants must have [Anaconda](https://anaconda.org/) installed and running on their Mac or Linux system. Participants who do not want to run the examples can simply watch the demos.

More about the tool: [https://fpchecker.org/index.html](https://fpchecker.org/index.html)

## Agenda

| Content                                | Duration |
| -------------------------------------- | -------- |
| Introduction & motivation              | 10 min   |
| FPChecker description                  | 15 min   |
| Installation                           | 15 min   |
| Exercise 1 (exceptions)                | 10 min   |
| Exercise 2 (FP32/FP64 exponent usage)  | 10 min   |
| Exercise 3 (annotations)               | 10 min   |
| Exercise 4 (parallel code)             | 5 min    |
| Conclusion / Q&A                       | 15 min   |

Total time ~ 1.5 hours

## Contact
For questions, contact Ignacio Laguna <ilaguna@llnl.gov>.
```
