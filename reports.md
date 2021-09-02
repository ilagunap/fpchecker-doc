---
title: "Reports"
keywords: sample homepage
layout: page
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: reports.html
summary: These instructions will help you get started with the FPChecker reports. All reports are HTML-based.
---

## Main Report
To generate the report, run `fpc-create-report` in the directory where the application was executed. You can add a title to the report usign the `-t` option: `$ fpc-create-report -t 'Application Name'`.
```
$ fpc-create-report
```
The report will be created in the `fpc-report` directory in the current directory:
```
$ ls ./
fpc-report
```


{% include image.html file="fpchecker/main_report.png" url="https://github.com/LLNL/FPChecker" alt="fpchecker" max-width=500  %}

The above picture shows the main report (located at `fpc-report/index.html`). The first column shows the classes of events detected. The second column shows the number of events detected. Finally, the third column shows the severity of the event type (high, medium, low).

Most of the time, the events of severity medium or low are benign and could be ignored (it can be, however, handy to know where they occur). However, attention should be paid to the events of high severity.

## Files Report

To see the files affected by an event, click on the number in the second column of the main report. For example, the picture below shows the file report for the NaN event. This report illustrates the files affected by that event in the application (first column) and the number of lines affected by that event (second column).

{% include image.html file="fpchecker/events_report.png" url="https://github.com/LLNL/FPChecker" alt="fpchecker" max-width=500  %}

This report shows also ther inputs that generated such event (in this case, NaN).

## Source Code Report

The source code report is shown by clicking on the Line column in the File Report (see example below). This report shows the lines of code affected by the event in the corresponding file. The affected code lines are highlighted.

{% include image.html file="fpchecker/source_report.png" url="https://github.com/LLNL/FPChecker" alt="fpchecker" max-width=500  %}
