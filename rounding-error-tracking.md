---
title: "Rounding Error Tracking"
keywords: advanced rounding error tracking
layout: page
sidebar: mydoc_sidebar
permalink: rounding-error-tracking.html
summary: High-level guide to FPChecker rounding-error accumulation, instrumentation modes, and line-based reporting.
---

This page explains:
- How FPChecker tracks rounding error (absolute and relative)
- How to enable this mode in practice
- How to use this mode for **mixed-precision** tuning

## What Is Being Tracked

For each instrumented floating-point operation, FPChecker computes:

- **Absolute rounding error:** the difference between a higher-precision recomputation (e.g., FP64) and the low-precision result (e.g., FP32).
- **Relative rounding error:** \|error\| / \|reference\| when the reference magnitude allows it.

At a high level, the runtime instruments low-precision operations at compile time
and recomputes each operation in higher precision during execution.
This enables estimation of propagated operand error and operation-level rounding error.
It then associates errors with source file and line information.

This allows reports to be filtered and discussed at source-line granularity.

## Enabling Rounding-Error Instrumentation With Wrappers

When using FPChecker compiler wrappers (`clang++-fpchecker`, `clang-fpchecker`, etc.), enable rounding-error instrumentation with:

```bash
FPC_INSTRUMENT_ERR_TRACKING=1 make -j
```

Do not use `FPC_INSTRUMENT=1` as this is for a different runtime system.

## If Wrappers Are Not Used (Manual Flags)

If your build system does not use wrappers, run:

```bash
fpchecker-show
```

and copy the rounding-error flags from the output (the section labeled `For rounding error tracking`).

For the full manual workflow, see [Adding compilation flags (Manual mode)](how-to-use.html#adding-compilation-flags-manual-mode), which shows how to get and apply the flags from `fpchecker-show`.

At a minimum, this mode requires adding the rounding runtime include and rounding 
plugin flags shown by `fpchecker-show` (for example, `Runtime_error.h` and `libfpchecker_error...`) 
to your compile flags.

## Rounding Error Accumulation (High Level)

In rounding-error mode, FPChecker keeps error metadata per operation and 
maps results back to source locations. Conceptually:

1. A floating-point instruction executes in FP32.
2. FPChecker recomputes an FP64 reference for that instruction.
3. The tool computes absolute and relative error.
4. The computed error is stored for the operation result.
5. When that result is used by later operations, the stored error is included in the next error calculation.
6. The error is attributed to the source line for reporting.

Because each operation can consume values that already carry error, FPChecker can propagate error information through the execution path and report an accumulated error level at later program points.

Simple propagation example:

```text
a = b + 0.1    -> compute error(a)
d = a * e      -> use error(a) and error(e) when computing error(d)
f = d - g      -> use error(d) and error(g), producing accumulated error at f
```

This allows developers to identify unstable hotspots and 
drive *mixed-precision* decisions with concrete line-level evidence (see below).

## How Results Are Reported Per Line

Rounding-error outputs are line-oriented:

- Reports show line-level entries so you can rank **hotspots** by relative error.
- For a given line, the summary view shows a single 
accumulated value (the last seen value for that line in the trace summary).
- If you need temporal evolution for selected lines, use `FPC_SAVE_LINE_ERRORS` 
to save the full sequence and plot it (as shown in `tutorial/example_5`).

## Example Rounding Error Report

The following is an example text report generated with:

```bash
$ fpc-create-report -s rounding

===== Rounding Error Report =====
Files with rounding errors: 1
Lines with rounding errors: 15
Max abs rounding error:   6.586799e+04
Max relative error:       5.148558e+05

--- File: /Users/lagunaperalt1/projects/fpchecker/FPChecker/tutorial/example_7/cg.cpp
Line   | Code                                                     |         Error |    Rel. Error
-------------------------------------------------------------------------------------------------
39     | guess = 0.5f * (guess + x / guess);                      |  5.132322e+02 |  9.998773e-01
52     | result += v1[i] * v2[i];                                 |  6.586799e+04 |  1.000000e+00
75     | result[i] += A[i * n + j] * v[j];                        |  2.300333e+01 |  9.583574e-01
90     | result[i] = v1[i] - alpha * v2[i];                       | -2.300333e+01 |  1.000020e+00
97     | result[i] = v1[i] + alpha * v2[i];                       | -2.199956e+02 |  1.184063e+00
111    | result[i] = r[i] + beta * p[i];                          |  1.090668e+04 |  1.000000e+00
146    | row.push_back(atof(token));                              |  0.000000e+00 |  0.000000e+00
229    | float alpha = rs_old / dot_product(p, Ap);               |  8.886326e-01 |  5.148558e+05
239    | float relative_residual = my_sqrt(rs_new) / relative_b;  |  7.291699e+02 |  1.000000e+00
248    | float beta = rs_new / rs_old;                            |  2.987656e-01 |  2.943871e-01
287    | float tolerance = (argc > 3) ? atof(argv[3]) : 1e-6f;    |  0.000000e+00 |  0.000000e+00
```

Image example of the same report type in HTML:

{% include image.html file="fpchecker/error_report.png" url="https://github.com/LLNL/FPChecker" alt="FPChecker rounding error report example" max-width=900 %}

## Minimal Workflow

```bash
make clean
FPC_INSTRUMENT_ERR_TRACKING=1 make
./your_app your_args
fpc-create-report -s rounding
```

For targeted line-series output (example: line 90):

```bash
FPC_SAVE_LINE_ERRORS=90 ./your_app your_args
```

This writes `errors_per_line_*.json`, which can be plotted to inspect how error evolves over repeated executions of that line.

## Mixed-Precision Tuning (Data-Driven)

The rounding-error report can be used as a practical guide for selective promotion from FP32 to FP64.

A common workflow is:

1. Run the FP32 code with `FPC_INSTRUMENT_ERR_TRACKING=1`.
2. Generate `fpc-create-report -s rounding`.
3. Rank lines by relative error (and absolute error when relevant to your application scale).
4. Promote only high-error lines and sensitive intermediates to FP64.
5. Re-run and compare residual/accuracy/performance.

Useful tuning heuristics:

- If a line repeatedly shows relative error above a project tolerance (for example, greater than 1e-5), consider promoting that operation to FP64.
- If relative error is 1.0 (100 percent) or higher, this often indicates severe *cancellation* or unstable arithmetic and is a strong candidate for FP64 promotion or formula reformulation.
- Keep low-error lines in FP32 when possible to preserve performance.

This enables a data-driven mixed-precision strategy: precision changes are made where the report shows numerical risk, instead of promoting code blindly.

## Limitations

This rounding-error tracking functionality is currently available only for programs written in FP32 (single precision).
