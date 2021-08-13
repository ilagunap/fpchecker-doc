---
title:  "Subnormal Numbers and Compiler Optimizations: A Dangerous Combination"
published: true
permalink: subnormal-numbers.html
sidebar: mydoc_sidebar
summary: "Several numerical inconsistencies can be caused by the combination of optimized code and subnormal inputs."
tags: [subnormal numbers, optimizations]
---

Subnormal numbers (previously known as denormal numbers) fill the underflow gap in floating-point arithmetic. Traditionally, an underflow computation is said to occur when the exact result of the calculation is nonzero but is smaller than the smallest normalized floating-point number. Subnormal numbers represent the result of computations that produce very small numbers but are not too small to become zero. 

While subnormal numbers are generated frequently in numerical software (e.g., scientific applications), combining such numbers with specific compiler optimizations can produce unexpected results. 

## Simple Example
Let’s examine an simple example where combining subnormal numbers and compiler optimizations produce inconsistencies.

Consider the following function that executes a division operation and makes a decision based on the result of the division: 
```cpp
void compute(double x, double y) {
  double z = x/y;
  if (z < 1.0)
    printf("Correct branch\n"); 
  else
    printf("Incorrect branch!!\n");
}
```

Compiling the code on an x86_64 system with the clang compiler and optimization level `-O3` (with and without the `–ffast-math` option), produces the expected result. If we use `1.1e-311` and `2.0e-309` for the input of `x` and `y`, the division produces `0.005499999999998974`, so the code prints:
```
$ ./test
Correct branch
```
Note that the inputs `x` and `y` are subnormal floating-point numbers, but this doesn't change the function's behavior.

We now compile the code on a different system. We use an IBM POWER9 system and compile it with the IBM `xlc` compiler using `-O3`. In this compiler, `-O3` automatically enables the non-strict IEEE mode, similar to the optimization mode of `–ffast-math` in the clang and gcc compilers. This time, using the same input, we get a different result:
```
$ ./test
Incorrect branch!!
```
We now lower down the optimization level in `xlc` to `–O2`, and this time we get the expected result:
```
$ ./test
Correct branch
```
What happened? How can we have a different behavior by simply changing the optimization level from `–O3` to `–O2`? 
To understand what happened, we can look at the assembly code (we use the Linus objdump tool to disassemble the code). Here’s a portion of the assembly code for the `–O2` case:
```
 7 0000000000000000 <compute>:
 8    0: 00 00 4c 3c   addis   r2,r12,0
 9    4: 00 00 42 38   addi    r2,r2,0
10    8: 91 ff 21 f8   stdu    r1,-112(r1)
11    c: a6 02 08 7c   mflr    r0
12   10: 80 00 01 f8   std     r0,128(r1)
13   14: c0 11 01 f0   xsdivdp vs0,vs1,vs2
14   18: 00 00 82 3c   addis   r4,r2,0
15   1c: 00 00 84 e8   ld      r4,0(r4)
16   20: 8c 03 01 10   vspltisw v0,1
17   24: 78 23 83 7c   mr      r3,r4
18   28: e2 03 20 f0   xvcvsxwdp vs1,vs32
19   2c: 58 01 01 f0   xscmpodp cr0,vs1,vs0
20   30: 20 00 81 41   bgt     50 <compute+0x50>
...
```
The interesting thing to note in the above assembly is that the division operation is in line 13; the `xsdivdp` instruction corresponds to a division in the POWER architecture. Let’s see now the assembly code for the `-O3` case:
```
 7 0000000000000000 <compute>:
 8    0: 00 00 4c 3c   addis   r2,r12,0
 9    4: 00 00 42 38   addi    r2,r2,0
10    8: 91 ff 21 f8   stdu    r1,-112(r1)
11    c: a6 02 08 7c   mflr    r0
12   10: 80 00 01 f8   std     r0,128(r1)
13   14: 68 11 80 f0   xsredp  vs4,vs2
14   18: 00 00 62 3c   addis   r3,r2,0
15   1c: 00 00 63 e8   ld      r3,0(r3)
16   20: 8c 03 01 10   vspltisw v0,1
17   24: 78 1b 64 7c   mr      r4,r3
18   28: e2 03 00 f0   xvcvsxwdp vs0,vs32
19   2c: 38 01 62 fc   fmsub   f3,f2,f4,f0
20   30: 88 1d 84 f0   xsnmsubadp vs4,vs4,vs3
21   34: 80 21 61 f0   xsmuldp vs3,vs1,vs4
22   38: 88 19 22 f0   xsmsubadp vs1,vs2,vs3
23   3c: 88 0d 64 f0   xsnmsubadp vs3,vs4,vs1
24   40: 18 19 00 f0   xscmpudp cr0,vs0,vs3
25   44: 1c 00 81 40   ble     60 <compute+0x60>
...

```
The division operation is gone with the `–O3` optimization level, and it was replaced with a reciprocal operation (`xsredp` instruction) followed by other operations, including multiplication.

We see that with the higher optimization level (`-O3`), the compiler optimizes the division operation and replaces it with potentially faster operations, which is wise and can potentially improve performance. However, this optimization makes the assumption that the inputs are represented as normal floating-point numbers. 

We add a `printf("z = %.17g\n", z);` statement to check the result of `z` with the `–O2` and `–O3` cases:

With `–O2`:
```
$ ./test 
z = 0.0054999999999989736
Correct branch
```
With `–O3`:
```
$ ./test
z = nan
Incorrect branch!!
```
The optimized code, which includes a reciprocal operation, produces a NaN; the inputs fall outside of the normal number representations (i.e., they are subnormal numbers), combined with the equivalent code produced by the optimizations results in the code taking an incorrect branch.

## Conclusion
If you are using highly optimized floating-point code, it is good to know whether your application is operating on subnormal numbers. Several numerical inconsistencies can be caused by the combination of optimized code and subnormal inputs. Knowing the functions and lines of code that use subnormal numbers is an excellent first step to understand potential numerical inconsistency issues. FPChecker can perform a complete floating-point analysis of applications and report code locations that produce subnormal numbers.


