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
Socket.io, since I've done similar things in the past, but I don't
like the idea of adding a middle-man to this situation, but the
interface from the javascript's end of things is pretty nice, so if I
could keep a similar interface that would be nice. One idea I had to
get rid of the middle man was just to use Node's ability to actually
insert C programs into itself, but it seemed like a fair amount of
overhead as well.

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

* [Thrift](http://thrift.apache.org/), which has js support and is
created by Facebook; looks like the currently most promising.

