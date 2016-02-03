---
layout: post
title: Summary of "Making Embedded Systems" by Elicia White
category: writeup
image: making_embedded_systems/cover.jpg
---

## Making Embedded Systems by Elicia White

### Initial Thoughts

Making Embedded Systems elucidated a bunch of nuggets of wisdom, but in doing
so, felt like a hodgepodge of disconnected ideas, thrown in when thought of and
lacking any coherent goal to strive towards.

### Main Review

#### Chapter 1: Introduction

The first chapter was a standard introduction to embedded systems. Elicia gave a
definition that I really liked, calling embedded systems purpose-built
computers. She also referenced the unique need to cross-compile when dealing
with embedded systems.

#### Chapter 2: System Architecture & Design

This was one of the meatier parts of the book, and was where Elicia really tried
drilling in an appreciation for good design by considering the architecture from
a couple of different perspectives, with heavy emphasis on design patterns. She
reccomends searching for the whole picture so you can effectively view the
entire system.

There are 3 main graphs that she reccomends to use when designing a system: the
architecture block diagram, the hierarchy of control organization, and the
software layer.

##### Architecture Block Diagram

![Architecture Block Diagram
]({{site.baseurl}}/assets/img/making_embedded_systems/abd.png "Architecture
Block Diagram")

This is the type of diagram that I most often draw when designing a new system,
and I find it immensely helpful. Elicia provides some good things to focus on
when constructing it.

You should focus on separating protocol from the peripheral at this stage. You
should also see by the connections made, which resources are shared more than
others.

##### Hierarchy of Control

![Hierarchy of Control
]({{site.baseurl}}/assets/img/making_embedded_systems/hierarchy.png "Hierarchy
of Control")

The hierarchy of control should be constructed by starting at a high level and
then working your way down from higher-level concepts to more low-level
implementation details. This also exposes the sharing of protocols and
interfaces in your design.

##### Layered View

![Layered View
]({{site.baseurl}}/assets/img/making_embedded_systems/layered.png "Layered
View")

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

Elicia, further elucidated on some very handy practices that can be employed to
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
of painful embedded debugging.

One last useful suggestion is to setup a style guideline. Elicia recommended
[Google's C/C++ Style Guide](https://google.github.io/styleguide/cppguide.html).

#### Chapter 3: Making your Code Work
#### Chapter 4: I/O & Timers
#### Chapter 5: Task Management
#### Chapter 6: Peripherals
#### Chapter 7: Updating Code
#### Chapter 8: Optimizing Code
#### Chapter 9: Embedded Math
#### Chapter 10: Optimizing Power

### List of Possibly useful references that Elicia mentioned

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

### Closing Takeaways for my Future Work
