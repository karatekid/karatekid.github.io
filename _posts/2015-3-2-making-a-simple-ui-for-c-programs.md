---
layout: post
title:  Making a Simple UI for C Programs
---

I'm working on a frontend application for the [Digilent Analog
Discovery](https://www.digilentinc.com/Products/Detail.cfm?NavPath=2,842,1018&Prod=ANALOG-DISCOVERY)
with Sam Oliver. Digilent offers a fairly straightforward SDK to
control and query the Discovery module with a .dll that is available
from a C program. I'm working on controlling it
from a javascript frontend, and the biggest problem seems to come down
to the actual communication between the two pieces of code. Sending
bytes of information over sockets wouldn't be that difficult, but
actually sending pieces of structured data and forming connections
seems like a much harder problem. So I tried finding an existing
solution. The first thing that came to mind was using Node.js and
[Socket.io](http://socket.io/), since I've done similar things in the past, but I don't
like the idea of adding a middle-man to this situation, but the
interface from the javascript's end of things is pretty nice, so if I
could keep a similar interface that would be nice. One idea I had to
get rid of the middle man was just to use Node's ability to actually
insert C programs into itself, but it seemed like a fair amount of
overhead as well.

I considered building my own setup using a C struct to JSON converter
like [JSON-C](https://github.com/json-c/json-c) or
[Jansson](https://github.com/akheron/jansson), but thought better of it.

I remembered using [LCM](https://lcm-proj.github.io/index.html) in EECS 467 with Professor Ed Olson, and the
idea of creating language agnostic data structures and then passing
them over sockets between client and server seemed pretty appealing.
So, I looked it up again and found some interesting information. LCM
uses a publish and subscribe interface, so you publish and subscribe
to separate channels to get and send information. It didn't offer
support for javascript though, which was dissapointing, I might want
to look into adding Javascript support for LCM at a later time. I
ended up finding a whole [list of tools out there like
LCM](http://en.wikipedia.org/wiki/Comparison_of_data_serialization_formats).
In data serialization formats, there are a couple of outstanding
systems that seemed highly used:

* [LCM](https://lcm-proj.github.io/index.html), which is highly used
in robotics, and seems like a straightforward approach. Sadly it
doesn't have supoort for javascript though.
* [Thrift](http://thrift.apache.org/), which has js support and is
created by Facebook; looks like the currently most promising.
* [Protocol Buffers](https://developers.google.com/protocol-buffers/),
built by Google and offering support for C++, Java, and Python it
seems powerful, but ill-suited to our sole purpose.
* [Hessian](http://hessian.caucho.com/), which seems a little
outdated, but purports to be optimized for performance.

I ended up deciding to use Thrift

## Setting up Thrift

I followed the straightforward approach [here](http://thrift.apache.org/).
It got a little tricky when supporting libraries and tools weren't
actually up to date. So I had to upgrade boost and go. Upgrading boost
was easy when I used this great
[tutorial](http://choorucode.com/2013/12/27/how-to-upgrade-the-boost-library-on-ubuntu/).
You can view your boost version number by looking in
`/usr/include/boost/version.hpp`. I actually had to redownload a newer
version, and then make it. I then added paths to my LDFLAGS and
CXXFLAGS in my `.bashrc` to allow the makefiles to work properly when
creating the cpp support. I was able to get that working, but
javascript support is running up agains an issue with an unsupported
method.

I got the javascript working by using someone else's repo that had
everything set up already [here](https://github.com/baali/thrift_js).
So, now I have everything set up to do communication. __The trick is to
use the JSON protocol and the HttpServer Transport__ in your cpp
server so that it is compatible with javascript.

Man, I've had a fair amount of problems with linking. It might be a
good idea to study these a little more in depth so I have a better
understanding of how Linux takes care of all of these different
things.

## Creating a Nice Makefile

I've typically used
[this](http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/) great
tutorial on Makefiles to structure my own in a desirable format.
Here are a couple more:

* [Opussoftware
 Tutorial](http://www.opussoftware.com/tutorial/TutMakefile.htm)
* [Make User Guide](http://www.gnu.org/software/make/manual/make.html)
* [JFranken Tutorial](http://www.jfranken.de/homepages/johannes/vortraege/make_inhalt.en.html#ToC12)
* [Some Makefile Template](https://gist.github.com/yorickvP/3171926)

I've found that my preference of Makefile design comes down to
preventing mindless repetition while keeping things clear. I'm going
to enumerate some of the things that I like to do in my Makefile, or
that I've learned about Makefiles.

* Makefiles are built around the idea of dependency rules
  * `<Target>: <Sources>` Is the general format of dependency rules
  * These execute recursively
* If you want to print out a helpful message you can use $(ECHO)
* To prevent make from printing out every line use `@` at the start of
your command
* `.PHONY: <name>` specifies that `<name>` is not a file
* `CC=gcc` is an example of a Macro
  * Macros are great, use them!
  * To use them wrap `CC` with `$()` to get `$(CC)`
* The from = to macro modifier is pretty handy it looks like:
  * `SRCS = $(OBJS:.obj=.c)`
  * You can use it to change file endings around
* The path substitution macro modifier allows you to work with
separate directories without using recursive Makefiles
  * `OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))` is an example of putting
an object file into the ODIR directory
* Special Functions:
  * `$(shell shellcmd)` runs shell command
  * `$(notdir path/file.c) --> file.c`
  * There's a whole lot more [where that came from](http://www.gnu.org/software/make/manual/make.html)
* Special strings:
  * `%` is an inference rule and can be used to infer file names, such as:
    * `%.o: %.c`
  * Automatic variables allow you to adapt infered rules
    * `$@` = the target of the executing dependency rule
    * `$<` = the first source
    * `$?` = all sources newer than the target
    * `$^` = set of all sources (no duplicates)
    * `$+` = list of all sources (same order, and duplicates)

This is a generic Makefile template that I created after looking
around at a couple of different Makefiles.
{% gist 2898342574038ec22a01 %}

Well now everything is setup to communicate between a javascript
frontend and a C / C++ backend! That's pretty awesome. I'm going to
add an entry about actually building the Oscilloscope controller
later.

