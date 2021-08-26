---
title: "Known Issues and Limitations"
keywords: sample homepage
layout: page
sidebar: mydoc_sidebar
permalink: known_issues.html
---

## Limitations of the CUDA Front-End

The FPChecker CUDA fron-end is work-in-progress and has some limitations:

- It doesn't instrument header files (only source files: .cu, .cpp, .c++, etc.)
- It requires using C++11
- The capabilities to parse macros and commets is good, but not perfect yet.

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
