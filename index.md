---
title: "FPChecker Overview"
keywords: sample homepage
layout: page_custom
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: index.html
toc: false
---

{% include image.html file="fpchecker/logo_fpchecker.png" url="https://github.com/LLNL/FPChecker" alt="fpchecker" %}

## Overview

FPChecker is a dynamic analysis tool to detect floating-point errors in HPC applications; it helps developers gain a better picture of what's happening in terms of floating-point arithmetic in their applications. It is the only tool of its class that supports common programming languages and models in HPC, including C/C++, MPI, and OpenMP. It is designed to be easy to use and easy to integrate into applications. The tool provides a detailed HTML report that helps users identify the exact location of floating-point issues, such as exceptions, in the software.

## Features

- **Easy to use:** it only requires a few changes to the application build script, such as changing the compiler (e.g., clang++) by the FPChecker compiler wrappers (e.g., clang++-fpchecker). It automatically instruments the code at build time.
- **Accurate detection:** it accurately detects issues dynamically (when code is executed) for specific inputs; it doesn’t give alarms for unused or invalid inputs. 
- **Designed for HPC:** it supports different programming languages and models in HPC: C/C++, MPI, OpenMP, and Pthreads.
- **Detailed report:** it provides a detailed report that programmers can use to identify the exact location (file and line number) of floating-point issues in the software.

<!--
{% include image.html file="fpchecker/report-1.png" url="https://github.com/LLNL/FPChecker" alt="fpchecker" max-width=500  %}
-->
{% include image.html file="fpchecker/main_report.png" url="https://github.com/LLNL/FPChecker" alt="fpchecker" max-width=500  %}

## Errors and Warnings

FPChecker detects the following floating-point issues:

- **Infinity +:** detected when operations produce positive infinity, for example, when 1.0 / 0.0 occurs. 
- **Infinity -:** this is the same as infinity +, except that the sign of the resulting calculation is negative.
- **NaN:** NaN (not a number) results from invalid operations, such as 0/0 or sqrt(-1).
- **Division by zero:** This occurs when a finite nonzero number is divided by zero. This typically produces either infinity or NaN.
- **Underflow (subnormal):** Underflow is detected when an operation produces a subnormal number because the result was not representable as a normal number. More [here](/subnormal-numbers.html).
- **Comparison:** This occurs when two floating-point numbers are compared for equality. Sometimes checking if two floating-point numbers are equal can lead to inaccuracies. More [here](https://floating-point-gui.de/errors/comparison/).
- **Cancellation:** cancellation occurs when two nearly equal numbers are subtracted. By default, this event is detected when at least ten decimal digits are lost due to a subtraction. More [here](2021-07-12-dealing-with-cancellation.html).
- **Latent Infinity +:** detected when an operation produces a large normal and is close to positive infinity.
- **Latent Infinity -:** detected when an operation produces a large normal number and is close to negative infinity.
- **Latent underflow:** detected when an operation produces a small normal number and is close to becoming an underflow (subnormal number).

## Exponent Usage
FPChecker profiles the code and quantifies the exponent usage of the application in FP32 and FP64 precision. For FP32 (single-precision) and FP64 (double-precision), these ranges determine the magnitude of the numbers that can be represented. While the internal representation uses a base 2 exponent, the equivalent range in base 10 is often used to provide a more intuitive understanding of the scale of numbers supported:

- <p>FP32: an approximate base 10 exponent range from 10<sup>−38</sup> to 10<sup>38</sup>.</p>
- <p>FP64: an approximate base 10 exponent range from 10<sup>−308</sup> to 10<sup>308</sup>.</p>

FPChecker can create histograms of the exponent usage in your application. Understanding the exponent usage in your application allows you to understand the numerical magnitudes your code operates on. This is useful when porting code to lower precision or mixed-precision.

{% include image.html file="fpchecker/exponent_usage.png" url="https://github.com/LLNL/FPChecker" alt="fpchecker" max-width=500  %}

## How FPChecker Works

FPChecker is designed as an extension of the clang/LLVM compiler. When the application is compiled, an LLVM pass instruments the LLVM IR code after optimizations and inserts check code to all floating-point operations. The check code calls routines in the FPChecker runtime system, which detects several floating-point events (see above). When the code execution ends, traces are saved in the current directory. These traces are then used to build a detailed report of the location of the detected events.

## Demo

<div style="width: 70%; margin: auto;"> <div style="padding:56.25% 0 0 0;position:relative;">
    <iframe src="https://player.vimeo.com/video/1083326382?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" frameborder="0" allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media" style="position:absolute;top:0;left:0;width:100%;height:100%;" title="fpchecker-video-May-2025"></iframe>
  </div>
</div>
<script src="https://player.vimeo.com/api/player.js"></script>


## Contact
For questions, contact Ignacio Laguna <ilaguna@llnl.gov>.

To cite FPChecker please use

```
Laguna, Ignacio. "FPChecker: Detecting Floating-point Exceptions in GPU Applications." In 2019 34th IEEE/ACM International Conference on Automated Software Engineering (ASE), pp. 1126-1129. IEEE, 2019.

Laguna, Ignacio, Tanmay Tirpankar, Xinyi Li, and Ganesh Gopalakrishnan. "FPChecker: Floating-point exception detection tool and benchmark for parallel and distributed hpc." In 2022 IEEE International Symposium on Workload Characterization (IISWC), pp. 39-50. IEEE, 2022.
```
