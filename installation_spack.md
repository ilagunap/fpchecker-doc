---
title: "Bulding FPChecker with Spack"
keywords: sample homepage
layout: page
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: installation_spack.html
summary: These brief instructions will help you get started to install FPChecker with spack.
---

[Spack](https://spack.readthedocs.io/en/latest/index.html) is a package management tool designed to support multiple 
versions and configurations of software on a wide variety of platforms and environments. 
To get started with Spack visit: [https://spack.readthedocs.io/en/latest/getting_started.html](https://spack.readthedocs.io/en/latest/getting_started.html).

## Installing Using the Spack Builtin Repo

Spack comes with thousands of packages in its built-in repository. Assuming you already have spack 
running in your system, the following will install the FPChecker package that comes 
from its built-in repository:
```
$ spack install fpchecker
```

## Installing Using the FPChecker Repo

As an alternative, we maintain a more updated version of the spack package in our own repo, 
which you can install creating a local repo. The following commands will create a local spack 
repo for FPChecker, will download the corresponding spack package file, and will 
install it using spack. 

### Create a local repo and add it to spack
```
$ spack repo create ./fpchecker_repo
$ spack repo add ./fpchecker_repo
$ mkdir ./fpchecker_repo/packages/fpchecker
```
### Download package file
```
$ wget https://raw.githubusercontent.com/LLNL/FPChecker/master/fpc_spack_repo/packages/package.py -P ./fpchecker_repo/packages/fpchecker/
$ ls ./fpchecker_repo/packages/fpchecker/
package.py
```
### Install
```
$ spack install fpchecker
```

## Loading FPChecker
```
$ spack load fpchecker
$ which clang++-fpchecker
/.../path/bin/clang++-fpchecker
```
