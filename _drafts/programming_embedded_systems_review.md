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

This section introduced the reader to embedded systems as a subject along with their
cultural and historical significance. It also dealt with dissecting a datasheet
to get at the meat of a peripheral and processor alike. Later on it elucidated
what was necessary to get an executable running on a processor and in the
process discussed compilers, linkers, and debuggers.

#### Chapter 1: Intro

A pretty standard introduction to embedded systems, highlighting their
importance and why the reader should care that they're reading this book. I'm
not sure how necessary this was, since I assumed that most readers would have
atleast some familiarity with embedded systems upon picking the book up. They
highlighted an important part of embedded systems (that they have real time
requirements) and all of the design decisions that it influences. The authors
then dissected a standard embedded systems application and laid bare it's main
components: input / output, memory, and a processor. In terms of software, this
leads to the application, driver, and hardware stacks - with the optional rtos
and network stacks thrown in there. This discussion naturally turned towards the
selection of processors and what tradeoffs to pay attention to: cost, speed,
memory, power consumption, and development cost being chief among them. Then the
authors harped on these notions while discussing examples.

One really good kernel of wisdom that was conveyed was that you should try to
avoid dynamic memory, and try to do as much as you could statically.

#### Chapter 2: Deciphering Datasheets

Chapter 2 was all about getting familiar with a new setup and getting ready to
crank out some good stuff. First and foremost they deal with getting familiar
with the hardware you're using. This involves thinking about how the data flows
and what the hardware's main purpose or selling point is. Making a block diagram at this
stage can be very helpful.

During this section they also gave a really good tip
by recommending that you keep a notebook for each project. This notebook would
contain software implementation notes as well as important device information.
This is helpful while you're working on your project and especially months or
even years later. Maybe I could put together a computerized version of this?

Later on the authors delve into the specifics of datasheets, breaking out what
the schematic icons mean, and so forth. Then they start getting into interesting
territory by getting into memory mapped I/O. They explain it as a way to access
peripherals while looking like you're just talking to memory, and regard it as
far superior to using a separate I/O space. When writing or reading to those
parts in MMIO, it can cause a peripheral to do something. They recommend making
a memory map of names to address ranges and eventually turning that into a
usable c header file.

The next aspect of embedded systems that they get into is communication with
peripherals, splitting it between polling and interrupts. They go into the
advantages of both and give a brief introduction to interrupts. I think they
could have used some more graphics and given a more thorough explanation of
interrupts.

Next they get into understanding your processor. And provide a list of questions
you should ask yourself when viewing it. They are:

* Where does it get an instruction after reset?
* What's the state after a reset?
* How are interrupts setup, do they need to be disabled?
* What's up with the interrupt vector table, and how do you acknowledge or
  disable interrupts?

They then delve into creating a slim driver for the peripherals.

Next they explain what goes into getting a good initialization on your
processor. I found this section **Especially Useful**, they break it up into 4
stages: reset, hardware initialization, startup, and calling main.

##### Reset
The reset
code is a small piece of assembly that needs to be located  at a processor
specific section of memory. Its sole job is to transfer control to the hardware
initialization step.

##### HW Initialization
The hardware initialization section informs the processor
of its environment and is a good spot to initialize the interrupt controller and
other critical peripherals. Note that these peripherals include things like
memory, not project-dependent items like an accelerometer. Once it's done all of
ROM and RAM should be available and interrupts should be in a sensical state.

* Disable interrupts
* Copy initialized data from ROM to RAM
* 0 the uninitialized data area

##### Startup Code
This should enable all other code that is written in a higher level language.
So, it should initialize the stack. This section was a little thin on what that
entailed. It should then call the main section.

* Allocate space for and initialize the stack
* Initialize the processor's stack pointer
* Call `main`

This section also introduced [Embedded Systems
Design](http://www.embedded.com/magazines) magazine, which seems like a treasure
trove of useful information.


#### Chapter 3: HW is for Hello World

This was a pretty straight forward example embedded systems application example.
It just involved working with GPIO and figuring out how to make a looping delay.

#### Chapter 4: From C to a HW Executable

This section dealt almost exclusively with compiling, linking, and loading using
gnu tools. It discusses the differences between standard compiling and
cross-compiling and breaks down the steps needed to get your code onto your
hardware into 3 steps. Source to object files, link them all into a single
relocatable object file, and then assign physical addresses to the relative
offsets within the relocatable program.

Common object file formats include COFF or ELF. The authors go into the nitty
gritty details of object files including the 4 sections: text (where code
resides), data (where initialized global variables reside), bss (where global
uninitialized data resides), and the symbol table where symbols are resolved.

Linking resolves the symbols using the symbol table and is typically done with
the gnu tool `ld`. It combines those various object files into the one
relocatable file.

The authors then go back into talking about the startup file and include some
more useful information. This was kind of frustrating, I've inserted this
information in my review of chapter 2 where I thought it shold be. A GNU package
called [libgloss](https://sourceware.org/newlib/) has good startup code for many
processors.

Then we need to assemble the startup code into an object file that can be used
in linking. A special linker command may be necessary to prevent standard
startup code from being generated. 

To convert the relocatable program into a usable binary we use a **locator**.
You must describe the physical layout of memory to the locator so it can assign
code and data segments properly to the hardware. This is built into `ld`, the
memory information must be passed in the form of a linker script. **Note**: use
of `ld` can be invoked with `gcc` and allows for correct inclusion of multilibs.

The result of linking and loading can give you a **map** file, which lists code
and data addresses for the final software image. Which seems pretty useful for
debuging. Another fun fact, is that you can use the `strip` command to get rid
of debug information in your executable without having to recompile. `objcopy`
can be used to change file types. `size` can inform you of section sizes. These
are mostly found within binutils.

#### Chapter 5: Running & Debugging that HW Executable

This chapter accentuated a couple of methods for going about debugging an
embedded system, chiefly debug monitors, remote debuggers, and emulators. It
also discussed a couple of methods that are useful for loading code and
optimizing / profiling code.

A debug monitor allows the user to download and run software in RAM while
exposing a command line interface which allows various accesses to the low level
hardware. This monitor is in non-volatile memory. A similar thing is a
bootloader, which can be used to transfer code to the system. You could
alternatively load code directly by overwriting ROM. The debug monitor runs on
the device.

A remote debugger can download, execute, and debug embedded software. There is a
client of sorts located on the device, while the main debugger resides on the
host computer, an example of such a debugger could be `gdb`. It allows you to
interact with RAM and various registers.

An emulator or (ICE) can do much more than a remote debugger by allowing you to view and
interact with ROM as well. It can also give you almost full control of the
processor, and can even allow you to set hardware breakpoints. The host
frontend is a remote debugger. Similar to emulators is a background debug mode
or JTAG, which I prefer.

The authors also mention simulators for testing code on the host machine. I
think it would be really enlightening to implement one. They also reccomend a
couple of tools for debugging hardware, such as logic analyzers, oscilloscopes,
setting GPIO pins for timing, and the like.

They also mention various development tools such as
[linters](http://www.embedded.com/electronics-blogs/beginner-s-corner/4023960/Introduction-to-Lint)
and version control.


### Core Embedded System Principles

#### Chapter 6: Memory

The authors did a good job of describing the various types of memory in this
section and also went into various ways of verifying and using it.

There are 3 types of memory RAM, ROM, and a hybrid of the two. RAM can be DRAM
or SRAM, the difference being that DRAM is less expensive but requires constant
refreshing by a DRAM controller. ROM can be PROM, EPROM, or masked memory.
Hybrid involves NVRAM, EEPROM, and Flash. Flash is great, but has the one
downside in that it has to be accessed at a sector by sector basis.

DMA is described as a way for hardware to do large memory operations in place of
the processor. Endinanness is discussed, big has MSB on the left and little has
MSB on the right (MSB = most significant byte). Big endian is used in TCP/IP, so
watch out for that in network stacks. You can use the `htons` and `ntohs`
commands - and compatriots - to convert to the right endianness when working in
a network.

Memory testing is covered thoroughly, and while interesting didn't seem all that
necessary for the purposes of the book. The authors identify the most common
issues of memory issues (a short or a flat) and use those to create useful tests
of memory. These includes tests for address collisions, the independence of
setting a 1 & 0 bit, and setting control bits. So these tests included a walking
1's test of data, then walking address 1's and testing all the others, and a
write increment and invert test.

Then they delve into the usefulness of checksums and in particular CRC. They
also mention filesystems and reference the typical FAT file system.

#### Chapter 7: Peripherals & Drivers

A fine delineation is made between on-chip & external peripherals. They
highlight how most of the operations you'll need to perform boil down to
creating good interfaces between control and status registers through MMIO.
Reminding you to use the `volatile` keyword then explaining bit manipulation
the wriers leave a pretty useful macro:

```c
#define BIT(X) (1 << (X))
```

They also talk about using structs with unions or a size identifier to more
declaratively access bits. After all of the bitfield stuff they get into the
essentials of good hardware abstraction and interfaces. They define some steps
which can be broken up into 5 main progressions:

1. Creating a memory mapped representation of control & status registers
2. Setting up variables to track state, temporary variables for write only
   registers
3. Creating an initialization method
4. Defining an API for the driver
  * This could include creating software devices, ie) a virtual timer
5. Setting up ISRs

They then use a serial device as an example, which could have been improvedwth
the use of some more visual aids, e.g. a datasheet screenshot.

Some additional add-ons that could be aded are error checking, configuration,
nicer functionalities, interrupts. Good design has to try to balance the
priorities of requirements, resource usage, and resource sharing.

#### Chapter 8: Interrupts

There are several ways code execution can be interrupted: traps, exceptions, and
interrupts fall pretty high on that list. Interrupts are asynchronous and have
some interesting properties that are useful to know when working with them. Some
are maskable, some aren't. Each interrupt has a number and a source. There are
also interrupt priorities that you need to establish to determine what should
get precedence over what. Also, you need to figure out whether your interrupts
should be able to nest, note that too much nesting could cause the stack to go
out of bounds.

After an interrupt comes in there are a few things that must happen:

1. Save state onto the stack, this includes the PC, registers, and flags
2. Acknowledge the interrupt
3. Restore context

1 & 3 are typically done automatically by the processor.

Setting up ISRs to respond to interrupts can get kind of tricky. The book
doesn't delve into too much detail on how that is acomplished, they don't
discuss the interrupt vector table too much or how interrupts actually work in
the hardware. It's good to include an interrupt map in your **notebook** listing
the number of the interrupt and the source that's coming in, maybe throw in the
pin number. When writing an ISR brevity is key, you can even hand the process
off to a deffered service routine (DSR) that gets executed in the main code,
some RTOS's necessitate that you do that. When defining the interrupt different
compilers use different methodologies to add the steps for 1 & 3, gnu uses the
`__attribute__` keyword mixed with an interrupt, while others just use the
`interrupt` keyword.


When different pieces of code are sharing variables, it can get tricky once
interrupts come into the mix. To guard sections that use these shared variables
we can lock them by disabling and enabling interrupts around them, we call those
parts of the code critical sections.

Then the authors branch off and discuss how timers work and the usefulness of
watchdogs, and give a good example by updating the LED blink code. They also
briefly mention schedulers.

When troubleshooting follow these steps:

* Get the first interrupt firing
* Ensure global ints are enabled
* Ensure its installed in the interrupt vector table
* Remember to have atleast a default ISR for all interrupt sources.
* Make sure process context is getting restored properly
* Know that you're acknowledging the interrupt
* Avoid race conditions
* Make sure you're enabling and disabling interrupts properly.

#### Chapter 9: Combining ^

This basically gave an example of the previous 3 sections by creating an example
terminal, it was mostly application details. I feel like it could have been
better integrated with the past 3 chapters.


### Operating Systems

#### Chapter 10: Operating System Fundamentals

Whole books have been written on operating systems, this section tries to deal
with the role that OS's play in embedded systems. Mostly, embedded systems have
real time requirements that need to be met, and various ways to coordinate
separate tasks, RTOS's try to alleviate that issue.

Multitasking is an important concept and you can easily craft examples in which
various tasks need to be completed within an embedded system. Each of these
tasks has deadlines that must be met. Thus the concept of threads are
born. There are 2 types of OS's thread-driven and event-driven. We'll be dealing
exclusively with thread driven. These threads need to be scheduled in a certain
way, some algorithms are FIFO, shortest job, round robin, and preemptive and
non-preemptive priority. There are also real-time scheduling algorithms that
include real time executive, EDF, min lax (available time - remaining time),
resource reservation, and my personal favorite rate monotonic scheduling (RMS).
These different types of scheduling have different requirements, for example
some need the tasks to be periodic.

RMS is pretty much the best static scheduler and is fairly straightforward to
implement. Also, you can verify if your tasks can be scheduled by checking the
worst case performance against this function

```
Wn = n * (2 ^ (1/n) - 1)
```

Which represents the minimum supported utilization by the algorithm per number
of tasks, utilization being (work / period). If your utilization is greater than
the value from the function it may still be schedulable, but you'll have to work
it out by hand. See Professor Mark Brehob. In this scheme, the lower the period,
the higher the priority.

Dynamic schedulers are pretty complicated, don't make your own.

In the scheduler every schedule tick you check if you need to switch tasks and
if you do, then you need to perform a context switch, which involves saving the:

* PC
* SP
* processor flags & registers
* Task control block
  * context
  * state
  * priority
  * entry-point fxn
  * task data
    * params
    * input

Each task has a state of ready, running, or waiting. The scheduler can be
blocked in critical sections.

To synchronize tasks you can use mutexes for shared resources and semaphores or
conditional variables for signalling. There are also event flags, spinlocks,
counters and alarms.

There is also the issue of priority inversion / inheritance when higher priority
tasks are blocking on lower priority tasks.

A cool way to communicate between tasks without using globals is to use message
passing, I'm a big fan of this and really appreciated its inclusion in
OpenPilot.

Integrating interrupts with schedulers can get tricky, sometimes you must use a
DSR with an ISR.


#### Chapter 11: RTOS example - eCos RTOS

#### Chapter 12: embedded Linux example


### Going Further

#### Chapter 13: Extending Functionality

#### Chapter 14: Optimizing


### List of Possibly useful references that they mentioned


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

* A standard C Makefile, style-guide, automatic linter (mostly a setup
  thing), and build setup for embedded systems (linker, locator, etc.)
  * Maybe setup a docker or puppet file or just a straight up VM with all the
    tools preinstalled
* Putting together a library of standard embedded utilities, perhaps in addition
  to the one recommended [newlib](https://sourceware.org/newlib/).
  * An error checking library wouldn't hurt
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

I could stand to learn more about the interactions between the computer that
compiles the code and the embedded system, chiefly chapters 4 & 5 which deal
with linking, loading, and debugging.

#### Next review

I found a couple things that I could do better when reviewing books:

* instead of summarizing everything just grab the couple nuggets of gold
