---
title: "How to Configure FPChecker"
keywords: sample homepage
layout: page
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: configuration.html
summary: These instructions will help you to configure FPChecker.
---

FPChecker is configured using environment variables. All variables have the `FPC_` prefix.

There are two classes of variables: _compile-time_ and _run-time_. Compile-time variables are enabled when building/instrumenting the application. Run-time variables are enabled when the application is executed.

The value of the variable does not matter; it only matters whether it is set or not.

## Availabe Variables

Here’s the list of available variables, their type, and description.

### Compile-time Variables

| Variable | Type | Description |
| FPC_INTRUMENT | Compile-time | Instruments the application |
| FPC_ANNOTATED | Compile-time | Indicates that the program is annotated |

### Run-time Variables

| Variable | Type | Description |
| FPC_EXPONENT_USAGE | Run-time | Profiles exponent usage for FP32/FP64 |
| FPC_TRAP_INFINITY_POS | Run-time | Program exits when Infinity positive is found |
| FPC_TRAP_INFINITY_NEG | Run-time | Program exits when Infinity negative is found |
| FPC_TRAP_NAN | Run-time | Program exits when NaN is found |
| FPC_TRAP_DIVISION_ZERO | Run-time | Program exits when division-by-zero is found |
| FPC_TRAP_CANCELLATION | Run-time | Program exits when cancellation is found |
| FPC_TRAP_COMPARISON | Run-time | Program exits when Comparison is found |
| FPC_TRAP_UNDERFLOW | Run-time | Program exits when underflow is found |
| FPC_TRAP_LATENT_INF_POS | Run-time | Program exits when Latent Infinity positive is found |
| FPC_TRAP_LATENT_INF_NEG | Run-time | Program exits when Latent Infinity negative is found |
| FPC_TRAP_LATENT_UNDERFLOW | Run-time | Program exits when Latent Underflow is found |
