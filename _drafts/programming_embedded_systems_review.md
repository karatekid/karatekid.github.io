---
layout: post
title: Summary of "Programming Embedded Systems" by Michael Barr & Anthony Massa
category: writeup
image: programming_embedded_systems/cover.jpg
---

## Preface

I've recently embarked on the lofty errand of writing a book on Embedded Systems.
After getting propositioned to write a book about quadcopters for Arduinos, the
idea about writing a book just got more and more enticing. But, after I lost
contact with the publisher and was eventually passed up for another author I
realized that I still wanted to write a book, but now I had the choice to write about
whatever I wanted. After some brief contemplation on a rocky crevass, I realized
that I wanted to get more bare-bones and make a bridge between software
developers that are interested in hardware (Arduino tinkerers) and embedded
systems engineers. So, in that vein, I've begun reading, rereading, and
experimenting with different embedded systems books and projects to try to
collect a good chunk of my embedded systems knowledge into a cohesive unit from
which I can filter out some hopefully helpful insights and lessons. So, here's a
review of a book that I just read on embedded systems.

## Programming Embedded Systems by Michael Barr & Anthony Massa

### Initial Thoughts

After reading the book I had a couple large takeaways. Barr and Massa both did a
great job of explaining what goes into dissecting a datasheet and they had a lot
of very helpful tips and tools to use when compiling and debugging. They also
explained memory in an interesting way by approaching it from the hardware
perspective and even supplying useful tests to test that your memory is
functioning properly. They highlighted the effectiveness of good abstraction
when writing hardware drivers and properly delineated them from typical kernel
drivers that you'd find on your operating system. They also explained the
usefulness of interrupts, but they seemed to stick to dealing with them in
software and didn't delve into how they work in hardware. Operating systems were
also expounded upon, focusing on threading, scheduling, and message queues (the
most relevant parts of an operating system in embedded systems).

### Book Layout

The book seemed to be split up into 3 and a half parts. 

1. Beginner setup and research
2. Core embedded system principles
3. Operating Systems
4. Miscellaneous ways to improve and extend your project (a half because it seemed like a superfluous add-on)


### Beginner Section

#### Chapter 1: Intro

#### Chapter 2: Deciphering Datasheets

#### Chapter 3: HW is for Hello World

#### Chapter 4: From C to a HW Executable

#### Chapter 5: Running & Debugging that HW Executable


### Core Embedded System Principles

#### Chapter 6: Memory

#### Chapter 7: Peripherals & Drivers

#### Chapter 8: Interrupts

#### Chapter 9: Combining ^


### Operating Systems

#### Chapter 10: Operating System Fundamentals

#### Chapter 11: RTOS example - eCos RTOS

#### Chapter 12: embedded Linux example


### Going Further

#### Chapter 13: Extending Functionality

#### Chapter 14: Optimizing


### Closing Takeaways for my Future Work

The selection of the ARCOM-viper development kit emphasized that I'm going to
need to chose a platform to use as an example. What should I use? I felt like
using the STM2F4 development board, seeing as it has some great specs and I've
worked with it before. After some more thought I realized that it might be a
better idea to use a processor that more people already have like the Arduino's
ATMEGA328P or ATMEGA2560, or the Raspbery Pi's BCM2835/6. I'm still trying to
figure out which would be most useful, but there's definitely something to be
said for having an easily available processor.

One thing that I found slightly stilted was the use of examples in the book.
They seemed tacked on at the end of explanatory sections and weren't really used
in the learning process apart from explaining applications of the theory. Maybe
a better approach would be to have more of a walkthrough - trying to reach a
goal by working through problems as they arise. That being said, I think this
worked prety effectively for someone who was merely using the book as a
refresher.

Since this book was published in 2006 it seems to have lost some relevancy in
terms of the hardware that was used in the examples even though most of the
embedded systems principles have stayed the same.

Something occured to me while I was reading this. There was a lot of text trying
to explain things when I think a couple of succint illustrations could have done
a much better job.

This book gave me a couple ideas for some future projects / things to set up:

* A standard C Makefile, style-guide, and automatic linter (mostly a setup
  thing)
* Putting together a library of standard embedded utilities, perhaps in addition
  to the one recommended [newlib](https://sourceware.org/newlib/).
* Creating a more standardized project hierarchy to allow for a smoother way of
  adding resources to projects, viewing, and reviewing them.
* A simulator for separate processors to allow easier testing of embedded code.
  It may be easier to use existing simulators e.g.
[simavr](https://github.com/buserror/simavr), but the process of building it
could be a very informative endeavour. Some of the intriguing issues would be to
get it to work properly with gdb and setting up a reasonable interface to
separate devices.
* Write a static scheduler. Most likely a RMS scheduler. I think it would be a
  great learning experience, especially since I was taught the theory quite in
depth in EECS 473 via Professor Brehob.
