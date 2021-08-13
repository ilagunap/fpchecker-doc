---
title:  "Floating-point Exceptions and GPU Applications"
published: true
permalink: 2021-07-12-exceptions.html
sidebar: mydoc_sidebar
summary: "Catching floating-point exepctions in GPUs is tricky."
tags: [errors, exceptions]
---

A floating-point exception occurs when an attempted arithmetic operation produces an abnormal result. For example, an exception arises when a program attempts to compute the square root of a negative number or when a division by zero occurs.

In traditional CPU-based programming languages and system software, several methods exist to detect floating-point exceptions. For example, in Linux systems, when exceptions occur, one of two things can happen. By default, the exception is simply noted in the floating-point status word, and the program can check the status word to find out which exceptions happened. Alternatively, traps for exceptions can be enabled, enabling the program to receive the SIGFPE signal (see [this](https://www.gnu.org/software/libc/manual/html_node/FP-Exceptions.html)). The default action for this signal is to terminate the program, but the effect of the signal can be changed.

GPUs are quickly dominating the HPC market and are becoming pervasive in the largest supercomputers. However, the support to detect floating-point exceptions in GPUs is sometimes limited and, in some cases, null. For example, NVIDIA GPUs have no mechanism to detect that a floating-point exception occurred according to the CUDA Programming Guide [1] version 11.

The CUDA Programming Guide also states other deviations of the CUDA implementation of floating-point arithmetic concerning the IEEE-754 standard, including that double-precision floating-point absolute value and negation are not compliant with IEEE-754 with respect to NaNs.

## Detecting Exceptions in CUDA

Since the traditional mechanisms to detect floating-point exceptions don't exist in CUDA, programmers are left with almost no option other than using printf statements in the application source code to catch the result of exceptions. Printing out the results of computations makes sense because the result of exceptions---infinity and NaN---propagate quickly to other calculations. For example, 2 x ∞ = ∞. So there is a good chance of observing such results in the application’s output.

{% include image.html file="fpchecker/gpu-1.jpg" alt="GPU" max-width=400 caption="Photo by Nana Dua on Unspalsh.com" %}

A significant downside is that printing in standard output from millions of GPU threads can be slow and error-prone. For example, some exceptions can be miss-detected, and they can affect control-flow without programmers even noticing them.

## FPChecker Detection
FPChecker can detect the result of exceptions in CUDA (and in the CPU code). For example, the tool detects operations that produce NaN, positive infinity, negative infinity, and subnormal numbers (underflows). Furthermore, it informs programmers of the location of the exception (file and line of code) and the first CUDA thread that encounters the exception. This information can be used in combination with a debugger to understand the origin of the error.

Mitigating floating-point exception often involves a deep understanding of the application’s algorithm, the modification of inputs, and adding if/then conditions in the code to deal with specific quantities---for example, if the denominator of a division is zero, some different action may be needed.


## References

[1] CUDA C++ Programming Guide: [https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html)

