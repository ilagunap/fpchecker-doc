---
title: "Binary Instrumentation Tool"
keywords: tools
layout: page
permalink: nvbit_tool.html
---

## Tool Description

This tool can detect NaN, Infinity (positive and negative), and subnormal quantities in NVIDIA GPU applications using binary analysis. As a result, it requires no re-compilation of the application and can analyze libraries. The tool uses the [NVBit tool](https://github.com/NVlabs/NVBit), which is provided by NVIDIA Labs.

## How to use it

Simply preload the shared library ` detect_fp_exceptions.so` before running the application using the Linux LD_PRELOAD variable method:
```
$ LD_PRELOAD=/path/detect_fp_exceptions.so ./application input
```
You should see the following output:
```
#FPCHECKER: Initializing...
#FPCHECKER: kernel void RAJA::internal::CudaKernelLauncherFixed…
#FPCHECKER: kernel …
```
## Error Reports

If a calculation that result in a NaN or infinity is found, you should see the following output:
```
#FPCHECKER: NaN found @ /tests/my_code/dot_product.cu:18
#FPCHECKER: INF found @ /tests/my_code/mult_matrix.cu:26
```
## Requirements

The GPU code must be compiled with the –generate-line-info flag (see the nvcc options [here](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#options-for-altering-compiler-linker-behavior-generate-line-info)).

Other requirements:
- SM compute capability: >= 3.5 && <= 8.6
- GCC version: >= 5.3.0
- CUDA version: >= 8.0 && <= 11.x
- nvcc version for tool compilation >= 10.2
