---
title: "Text Reports"
keywords: sample homepage
layout: page
sidebar: mydoc_sidebar
permalink: text_reports.html
summary: These instructions will help you get started with the FPChecker text reports.
---

## Main Report

FPChecker can print the report in standard output using the `-s` option:

```
$ fpc-create-report -s
Generating FPChecker report...
Trace files found: 8

================== Main Report ===================
positive_infinity              0
negative_infinity              0
nan                            430
division_by_zero               0
cancellation                   123068684
comparison                     0
underflow                      0
latent_positive_infinity       0
latent_negative_infinity       0
latent_underflow               0
```

## Files and Inputs

To see the lines and inputs affected by a given event, provide the event name to the `-s` option (e.g., positive_infinity or nan):

```
$ fpc-create-report -s nan
Generating FPChecker report...
Trace files found: 8

===== Nan Report =====
/usr/workspace/wsa/laguna/fpchecker/cpu_checking/apps/LULESH/lulesh-util.cc:208

===== Inputs =====
./lulesh2.0 -i 10 -p
```

## Rounding Error Text Report

FPChecker can also print a rounding error text report with line-level error information:

```bash
$ fpc-create-report -s rounding
```

Example output:

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

This report includes, per affected file and line:

- Source line number
- Source code snippet (when available)
- Absolute rounding error (`Error`)
- Relative rounding error (`Rel. Error`)

These metrics help identify numerically unstable operations and prioritize selective FP32/FP64 promotion in mixed-precision workflows.

For complete details, interpretation guidance, and examples, see [Rounding Error Tracking](rounding-error-tracking.html).
