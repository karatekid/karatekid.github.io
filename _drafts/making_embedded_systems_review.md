---
layout: post
title: Summary of "Making Embedded Systems" by Elecia White
category: writeup
image: making_embedded_systems/cover.jpg
---

## Making Embedded Systems by Elecia White

### Initial Thoughts

Making Embedded Systems elucidated a bunch of nuggets of wisdom, but in doing
so, felt like a hodgepodge of disconnected ideas, thrown in when thought of and
lacking any coherent goal to strive towards.

### Main Review

#### Chapter 1: Introduction

The first chapter was a standard introduction to embedded systems. Elecia gave a
definition that I really liked, calling embedded systems purpose-built
computers. She also referenced the unique need to cross-compile when dealing
with embedded systems.

#### Chapter 2: System Architecture & Design

This was one of the meatier parts of the book, and was where Elecia really tried
drilling in an appreciation for good design by considering the architecture from
a couple of different perspectives, with heavy emphasis on design patterns. She
reccomends searching for the whole picture so you can effectively view the
entire system.

There are 3 main graphs that she reccomends to use when designing a system: the
architecture block diagram, the hierarchy of control organization, and the
software layer.

##### Architecture Block Diagram

{% include figure.html url='/assets/img/making_embedded_systems/abd.png'
caption='Architecture Block Diagram'%}

This is the type of diagram that I most often draw when designing a new system,
and I find it immensely helpful. Elecia provides some good things to focus on
when constructing it.

You should focus on separating protocol from the peripheral at this stage. You
should also see by the connections made, which resources are shared more than
others.

##### Hierarchy of Control

{% include figure.html url='/assets/img/making_embedded_systems/hierarchy.png'
caption='Hierarchy of Control'%}

The hierarchy of control should be constructed by starting at a high level and
then working your way down from higher-level concepts to more low-level
implementation details. This also exposes the sharing of protocols and
interfaces in your design.

##### Layered View

{% include figure.html url='/assets/img/making_embedded_systems/layered.png'
caption='Layered View'%}

When constructing a layered view of your system, you can use the size of the
block to show how much time you estimate it will take. Also, opposite from the
hierarchy diagram, you want to build this from the lowest level, going up. As
you build the layer, you should have any higher level blocks overlap with any
lower level blocks that they use. This makes pieces of code that touch many
others larger, and thus perceived as more difficult, since the more dependencies
code has the more complex it usually becomes.

##### Creating an Architecture from the Diagrams

These diagrams can be very helpful, and should be reviewed and rewritten
constantly. When reviewing it try to think about what could change. What can be
grouped together, e.g. 2 components that only talk with one another, could be 1
component. Similarly, would it make more sense to split separate tasks up. This
is an important part of the design process where you should clarify the API's
between separate components and (if you have people to delegate to) delegate
the construction of those components. The point being, that these should now be
very well-defined and separable units.

Elecia, further elucidated on some very handy practices that can be employed to
allow for good debugging and design of your code.

Most of her drivers attempt to use the standard linux driver interface of
(`open`, `close`, `read`, `write`, `ioctl`). Having a standard interface can
help you swap in separate drivers very easily or simply think about different
components with a more standard approach. This hiding of specifics of the actual
implementation by a standardized interface is referred to as an adapter and is
always very handy in forming good abstraction.

Logging is used a design example and a few points are expounded upon, while
giving a great design for a very useful part of any embedded system. She
highlights the need for levels, a global on/off, versions, and a logging output
that consists of the system, level, message, and an optional number, to avoid
the need for costly `printf`s. A couple of good C design points are discussed,
such as the use of singletons: a once constructed item, where all subsequent
calls of instantiation simply return the first created object.

MVC frameworks are then discussed in terms of embedded systems and particularly
as a means of testing them. A human readable file, a csv for example can be
used to generate input to algorithms which then generate output files. These
output files can be checked against over and over to perform useful regression
tests. Also, when you get to test on your local computer you often avoid a lot
Mjjkjof painful embedded debugging.

One last useful suggestion is to setup a style guideline. Elecia recommended
[Google's C/C++ Style Guide](https://google.github.io/styleguide/cppguide.html).

#### Chapter 3: Making your Code Work

Chapter 3 was all about understanding parts, and being able to see inside
(debug) things when they weren't working. So, this chapter has a couple of big
points: reading datasheets, understanding your processor, reading a schematic,
collecting a good set of debugging tools, and testing your system. On top of
that, Elecia elucidates the general steps of a project.

Most projects start with hardware selection, followed by board layout. This soon
progresses into hardware tests to verify that all of the connections are
properly made. Then there is the long cycle of software development work. The
Gantt chart below elucidates the flow of most embedded projects.

{% include figure.html url='/assets/img/making_embedded_systems/gantt_chart.png'
caption='Gantt Chart of Embeded Systems Development'%}

##### Reading a Datasheet

Elecia lists all of the different parts of a datasheet along with helpful
insights into what information to watch out for, these include the introductory
description, the pin descriptions & layout, the schematics, any sample code, the
performance characterization, and most importantly the application information /
theory of operation. She also makes a note to look for any errata that the
distributor may put out to fix previous documentation or device issues.
Evaluating this list of fields will help determine if a certain peripheral can
be used and if so, how easy it will be to implement.

##### Understanding a Processor & Reading a Schematic

A processor is the brain of any embedded system, as such, understanding a
processor can make the difference between a working and a broken project. Elecia
recommends using the user manual, getting started documentation, forums, and
datasheet to really get a solid understanding of your processor. Understanding
the schematic of your board isn't too complicated and boils down to assigning
meaning to the most connected pieces on the schematic, which tend to be the most
important.

##### Debugging

A good hardware debugging toolbox is comprised of:

* Needle nose pliers
* Tweezers
* Box Cutters
* DMM (remember only test for resistance when the device is turned off)
* Electric tape
* Sharpie
* Screwdrivers
* Flashlight
* Magnifying glass
* Safety glasses
* Cable ties

Other extremely useful tools are oscilloscopes and logic analyzers. Elecia
spends some time discussing how to use them, and their parts; including the time
scale, voltage scale, and zero-offset.

##### Testing

In this section, Elecia really exposes her wealth of experience with work on
embedded projects. She notes 3 main types of tests: POST, unit tests, and bring
up tests. POST tests stands for Power On Self Test, and should be run every time
on boot to check that everything is connected properly. Unit tests should
atleast be run at every release, and it is a good idea to try to leave them in
production for easy debugging. The bring up tests should check specific
subsystems and are usually one-off / throwaway tests. Elecia uses Flash as a
good example for tests, including the reading, byte access, and block access of
flash in her tests.

Having a command and response debugger can also be very helpful for selectively
running separate functions. Here's a code-snippet of the structure that Elecia
uses in her debugger.

{% highlight c %}
typedef void(*functionPointerType)(void);
struct commandStruct {
    char const *name;
    functionPointerType execute;
    char const *help;
};
const struct commandStruct commands[] = {
    {"ver", &CmdVersion, "Display firmware version"},
    {"flashTest", &CmdFlashTest, "ReRuns the flash unit test, printing out the number of errors"},
    {"blinkLed", &CmdBlinkLed, "Sets the LED to blink at a desired rate (parameter: frequency (Hz))"},
    {"",0,""} //End of table indicator. MUST BE LAST!!!
};
{% endhighlight %}

Elecia further recommends the use of an eror handling library with a
well-defined errors file to know which codes mean what. This library should
usually set a global error flag, and have an interface comprised of `set`,
`get`, `print`, and `clear` functions.

#### Chapter 4: I/O & Timers

This chapter starts off by diving right into the use of registers, how that
extends to memory-mapped IO, and the consequent need for a proficiency in binary
operations. We then delve into how I/O has different types and directions and
how it all depends on the vendor. Elecia recommends having a board-specific
header file which can be selectively included like this:

{% highlight c %}
// ioMapping.h
#if COMPILING_FOR_V1
#include “ioMapping_v1.h”
#elif COMPILING_FOR_V2
#include “ioMapping_v2.h”
#else
#error “No IO map selected for the board. What is your target?”
#endif /* COMPILING_FOR_*/
{% endhighlight %}

Then she describes how different response times feel:

| Sluggish | Good | Snappy |
| -------- | ---- | ------ |
| 250 ms   | 100 ms | 50 ms |

We then get into the good stuff, with Elecia describing the differences between
interrupts and polling. She then implements a neat button debouncer using a
timer and a filter.

Then the design patterns get into the mix. Elecia compares the __Facade__
pattern with __Dependency Injection__. __Facade__ reduces complexity by
simplifying the lower-level interface. With the LED example that she gives, this
is done by abstracting away the IO interface into the LED code. It makes the LED
code rely on the IO though. __Dependency Injection__ aims to increase
flexibility; as an example you'd pass in a IO handler to the LED code, so you
could do anything when turning it on. This is handy when working with different
boards, or even for testing, for example you could write to a file instead of
turning an IO pin on. __Facade__ pattern takes up more space, but __Dependency
Injection__ can add to the run time, due to the use of function pointers.

Then we take a good look at timers, evaluating their various registers which can
include: total_time, compare, action, clock, prescale, control, and interrupt.
Here's a neat algorithm to settle on a pre-scalar & compare value:

{% include figure.html url='/assets/img/making_embedded_systems/timer_algo.png'
caption='A brute-force algorithm to select compare and prescalers for a timer'%}

Note that the main issues to solve here are the limited width of the register
and the fact that we're working with integers instead of floats. Elecia then
makes a lovely transition from the discussion of timers to describing PWMs as 2
timers.

#### Chapter 5: Task Management

Elecia prefaces this chapter by stating that chapter 2 was the _what_/_why_ of
design and this is the _how_.

##### OS

We start off fast by diving right into operating
systems, and distinguishing between __tasks__, __threads__, and __processes__.
We then get into scheduling and communication between threads (Elecia uses
globals). We establish separation of __critical sections__ via mutexes, which
can, at their very simplest, disable interrupts. She has a view on semaphores,
that I haven't seen before, she refers to them as such:

> Operating systems have heavier weight mutexes called semaphores that
can handle situations where a thread or process can be preempted (for-
cibly changed by the scheduler).

I've only ever dealt with semaphores that are used as an alternative to mutexes
and are usually better for signaling between producers and consumers, but don't
take my word for it. Make sure that when you're in your __ISR__ that you finish
quickly. Elecia also gets into why we need priority inversion and how it works.

{% include figure.html url='/assets/img/making_embedded_systems/priority_inv.png'
caption='Priority Inversion'%}

##### FSM

Elecia then gets into __Finite State Machines__ which, put very simply allow a
change of behavior when the state changes. It usually is implemented with a
switch statement, you can separate this `next_state` utility into a function.
Alternatively, it can be event-centric. These usually need 5 functions to use
for each state: `enter`, `exit`, `go`, `stop`, `periodic_housekeeping`; `go` and
`stop` are implementation specific event handlers, there could be many more of
these event handlers, but her example is a stoplight, so these handlers make
sense. Alternatively you can use a table to keep track of your FSM, in it you
have a pointer to what do to do in a `go`, `stop`, and `timeout` situation as
well as a `light` that's associated with that state. Then there are global
handlers that call the necessary functions when they are required.

##### Interrupts

Once an interrupt occurs a very particular set of steps takes place:

1. IRQ
2. Save Context
3. Go to the IVT (Interrupt Vector Table) for the Callback
4. Execute the Callback
5. Restore the Context (Elecia, didn't mention this, as it's often take care of
   by the compiler, as is #2

She quickly makes a distinction between a normal interrupt and an exception. The
use of separate set & clear registers is shown to prevent interrupt issues since
you don't have to read any register to clear / set a bit. There's also a quick
reminder about setting global interrupts. There's a quick discussion about
interrupt priority and nested interrupts. Elecia recommends staying away from
nested interrupts, and I must say that I agree with her. Interrupt latency is
taken into consideration, as an overall metric of the processor.

Functions called from the IRQ must be __reentrant__, which means that they can
be run multiple times without being complete; this makes most functions that
use global state __non-reentrant__. There's a good example of where the vector
table is located in the LPC17xx:

{% highlight c %}

__attribute__ ((section(".isr_vector")))
void (* const g_pfnVectors[])(void) = {  // * markdown fix
    // Core Level - CM3
    &_vStackTop,
    // The initial stack pointer
    ResetISR,
    // The reset handler
    NMI_Handler, // The NMI handler
    ...
    TIMER2_IRQHandler, // 19, 0x4c - TIMER2
    TIMER3_IRQHandler, // 20, 0x50 - TIMER3
    UART0_IRQHandler, // 21, 0x54 - UART0
    ...
}
{% endhighlight %}

There's a useful hint about saving the interrupt status when you disable it, so
that when you re-enable you don't accidentally turn it on, when they were
already off. The concept of a __system tick__ is explained and the reader is
made aware of it's necessity in any scheduler. A small pseudo-scheduler is
explained that uses a pub/sub model. Then the concept of a watchdog is
explained, noting its ability to greatly increase the robustness of a system.

#### Chapter 6: Peripherals

#### Chapter 7: Updating Code

#### Chapter 8: Optimizing Code

#### Chapter 9: Embedded Math

#### Chapter 10: Optimizing Power

### Closing Takeaways for my Future Work

### List of Possibly useful references that Elecia mentioned

* [Design Patterns: Elements of Reusable Object-oriented
  Software](https://www.goodreads.com/book/show/85009.Design_Patterns)
* [Head First Design
  Patterns](https://www.goodreads.com/book/show/58128.Head_First_Design_Patterns?from_search=true&search_version=service)
* [Object Oriented Programming in
  ANSI-C](http://www.fritzsolms.net/sites/default/files/documents/STCD_C.pdf) I
think?
* [Make:
  Electronics](http://www.amazon.com/Make-Electronics-Discovery-Charles-Platt/dp/0596153740)
* [Designing Embedded
  Hardware](https://www.goodreads.com/book/show/461146.Designing_Embedded_Hardware)
* [A Guide to Debouncing](http://www.eng.utah.edu/~cs5780/debouncing.pdf), a
  great article on the causes of bounce and the solutions of it
* [Operating Systems Design and
  Implementation](http://www.amazon.com/Operating-Systems-Design-Implementation-Edition/dp/0131429388)
* [Programming the
  6502](http://www.amazon.com/Programming-6502-Rodnay-Zaks/dp/0895881357), or
other processors from around 1980 give good references
* [The Scientist and Engineer's Guide to Digital Signal
  Processing](http://www.dspguide.com/)
* [Signals &
  Systems](http://www.amazon.com/Signals-Systems-Edition-Alan-Oppenheim/dp/0138147574)
* [The Art of Control
  Engineering](http://www.amazon.com/The-Art-Control-Engineering-Dutton/dp/0201175452)
* [Smart Card
  Handbook](http://www.amazon.com/Smart-Card-Handbook-Wolfgang-Rankl/dp/0470743670), a good book about security
* [James Lynch's Serial Communications Tutorial for the
  AT91SAM7](https://www.sparkfun.com/datasheets/DevTools/SAM7/at91sam7%20serial%20communications.pdf),
a handy tutorial on setting up open-source tools
* [AVR035: Efficient C Coding for
  AVR](https://www.element14.com/community/docs/DOC-31079/l/atmel-avr035--application-note-for-efficient-c-coding-for-8-bit-avr-microcontrollers)
* [Hacker's Delight](http://www.hackersdelight.org/)
* [Art of Computer
  Programming](http://www-cs-faculty.stanford.edu/~uno/taocp.html),
specifically Vol. 2 for the great algorithms
* [Art of
  Electronics](http://www.amazon.com/The-Art-Electronics-Paul-Horowitz/dp/0521370957)
* [Numerical Recipes: The Art of Scientific
  Computing](http://www.amazon.com/Numerical-Recipes-3rd-Edition-Scientific/dp/0521880688)
* [There Are No Electrons: Electronics for
  Earthlings](http://www.amazon.com/There-Are-Electrons-Electronics-Earthlings/dp/0962781592)
* [MSP430 Coding Techniques App
  Report](http://www.ti.com/lit/an/slaa294a/slaa294a.pdf)
