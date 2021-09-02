---
title: "Exiting on Events"
keywords: sample homepage
layout: page
sidebar: mydoc_sidebar
permalink: traps.html
summary: These instructions show how to allow the program to exit when an event is detected.
---

## Exiting on Events

FPChecker can exit on the first detected event. To enable this option, the following environment variables can be set:

```
FPC_TRAP_INFINITY_POS
FPC_TRAP_INFINITY_NEG
FPC_TRAP_NAN
FPC_TRAP_DIVISION_ZERO
FPC_TRAP_CANCELLATION
FPC_TRAP_COMPARISON
FPC_TRAP_UNDERFLOW
FPC_TRAP_LATENT_INF_POS
FPC_TRAP_LATENT_INF_NEG
FPC_TRAP_LATENT_UNDERFLOW
```

For example, to exit when NaN or positive infinity events are detected, run:
```
$ FPC_TRAP_NAN=1 FPC_TRAP_INFINITY_POS=1 ./program
```
If an event is found, the program will print a message and exit:
```
#FPCHECKER: Interrupting execution...
#FPCHECKER: nan
#FPCHECKER: /path/to/compute.cpp:26
```

{% include important.html content="The program must be instrumented to allow the FPChecker runtime to detect events." %}

## Files and Lines

We can also ask FPChecker to only exit on specific files or lines by setting these environment variables:
```
FPC_TRAP_FILE
FPC_TRAP_LINE
```
For example, the following will indicate to exit only when a NaN is found in file `comp.cpp` and line `7`
```
$ FPC_TRAP_NAN=1 FPC_TRAP_LINE=7 FPC_TRAP_FILE=”comp.cpp” ./program
```

{% include note.html content="FPChecker will match files that end with the value provided in FPC_TRAP_LINE. For example, ”/path/comp.cpp” and =”file_comp.cpp” will both match." %}
