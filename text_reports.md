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
