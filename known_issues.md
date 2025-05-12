---
title: "Known Issues and Limitations"
keywords: sample homepage
layout: page
sidebar: mydoc_sidebar
permalink: known_issues.html
---

## Makefile wrapper (automatic mode)

The automatic mode (`fpchecker` wrapper) only works in Linux when the `LD_PRELOAD` trick is allowed.

## Passing Strings to the Compiler

Occasionally one must pass quoted strings as compiler arguments. A common example 
occurs when adding definitions to the compiler command line:
```
$ clang++ -c file.cpp -DMY_STRING=\"version_0.1\"
```
which could be used in the program like this:
```cpp
std::string s(MY_STRING);
std::cout << "Program version: " << s << "\n";
```

FPChecker will fail because the shell will remove the backslashes and FPChecker will 
get `"version_0.1"` as opposed to `\"version_0.1\"`.

The solution is to escape both the backslash and the quote like this:
```
$ clang++ -c file.cpp -DMY_STRING=\\\"version_0.1\\\"
```
