---
title: "Exponent Usage Histograms"
keywords: sample homepage
layout: page
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: exponent-usage.html
summary: This functionality helps you understand the floating-point exponent usage in your application.
---

## Background on Floating-Point

Floating-point numbers are represented in the following form:

significant x 2^exponent,

where significant (or mantissa) and exponent are integers.

The FP32 (32-bit) floating-point format uses 8 bits for exponents. FP32 exponents range from −126 to +127; exponents of −127 (all 0s) and +128 (all 1s) are reserved for special numbers. Similarly, the FP64 (64-bit) floating-point format uses 11 bits for exponents. FP64 exponents range from −1022 to +1023; exponents of −1023 (all 0s) and +1024 (all 1s) are reserved for special numbers.

## Exponent Usage Histograms

FPChecker can create histograms of the exponent usage in your application. Understanding the exponent usage in your application allows you to understand the numerical magnitudes your code operates on.

To enable exponent usage histograms, define the following variable in your compilation flags:

```
-DFPC_EXPONENT_USAGE
```

## Reports

Once you run the application, traces will be saved in the `.fpc_log` directory (one trace per process). To generate a report, execute the following command in the directory where the application ran:

```
$ fpc-create-usage-report
```

A directory called `fpc-report` will be generated with report. Open `index.html` in that directory.

## Plots

Histogram plots show the number of times a range of exponents were used in the floating-point operations of your application. The report provides a histogram plot for the entire program and different histogram plots for the application files.

## Sample Reports

These are some sample reports from open-source applications:
- LULESH
- AMG
