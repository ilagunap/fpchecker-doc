---
title: "Exponent Usage"
keywords: sample homepage
layout: page
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: exponent-usage.html
summary: This functionality helps you understand the floating-point exponent usage in your application.
---

FPChecker profiles the code and quantifies the exponent usage of the application in FP32 and FP64 precision. 
For FP32 (single-precision) and FP64 (double-precision), the ranges determine the magnitude of 
the numbers that can be represented.

Checking that the application stays within bounds is important for several reasons:

- Avoiding overflows and underflows
- Checking that mixed-precision code is correct

## Background on Floating-Point

Floating-point numbers are represented in the following form:
```
significant x 2^exponent
```
where significant (or mantissa) and exponent are integers.

The FP32 floating-point format uses 8 bits for exponents. FP32 exponents range from −126 to +127; exponents of −127 (all 0s) 
and +128 (all 1s) are reserved for special numbers. Similarly, the FP64 (64-bit) floating-point format uses 11 bits for exponents. FP64 exponents range from −1022 to +1023; exponents of −1023 (all 0s) and +1024 (all 1s) are reserved for special numbers.

While the internal representation uses a base 2 exponent, the equivalent range in base 10 is often used to provide a more intuitive understanding of the scale of numbers supported:

- <p>FP32: an approximate base 10 exponent range from 10<sup>−38</sup> to 10<sup>38</sup>.</p>
- <p>FP64: an approximate base 10 exponent range from 10<sup>−308</sup> to 10<sup>308</sup>.</p>

## Exponent Usage Histograms

FPChecker can create histograms of the exponent usage in your application. Understanding the exponent usage in your application allows you to understand the numerical magnitudes your code operates on. This is useful when porting code to lower precision or mixed-precision.

To enable exponent usage histograms, define the `FPC_EXPONENT_USAGE` variable at runtime.

## Reports

Once you run the application, traces will be saved in the `.fpc_log` directory (one trace per process). 
To generate a report, execute the `fpc-create-report` command. A directory called `fpc-report` will be generated with report. Open `index.html` in that directory.

## Plots

{% include image.html file="fpchecker/exponent_usage.png" url="https://github.com/LLNL/FPChecker" alt="fpchecker" max-width=500  %}
