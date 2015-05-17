---
layout: post
title: Using a Mojo to query a large array of Ultrasonic Sensors (HCSR04)
category: project
---

You can use a large array of ultrasonics on an arduino, but it can get
pretty messy and the precise timing constraints can really make it
hard to write any other code, an example of this can be found
[here](http://playground.arduino.cc/Code/NewPing). 
So, I'm looking into writing a verilog
module to effectively query an HCSR04. On top of that I want to make
an easy way to communicate between an arduino and a Mojo, or atleast
use an existing method. I think it might have SPI support already.

Steps:
1. Get Mojo workflow setup, (it's been a while)
2. Setup comms, so can verify verilog module works
3. Make HCSR04 verilog module based off of NewPing Library

## Getting Mojo Environment Setup

There are a lot of great tutorials
[here](https://embeddedmicro.com/tutorials/mojo-fpga-beginners-guide/).
I followed them to get most of the information I'll be summarizing
here. I setup something called a mojo-loader, which uploads the
synthesized .bin file to the mojo and is just a .jar executable
itself. I use ISE by Xilinx to do the actual verilog synthesis. Mojo
provides a pretty nice basic template that they call
mojo-base-project. Note that all of your code should go in the src/
directory inside of that. To synthesize, make sure mojo\_top.v is
selected and then click "Generate Programming File". Then uploading
the generated .bin file is as simple as using the mojo-loader gui.

To use certain external I/O pins on the FPGA we need to modify the UCF
(User Constraints File) in the src directory. Our change should look
something like this:  
`Net "button" LOC = P50 | IOSTANDARD = LVCMOS33;`

## Serial Communication

To communicate with an external arduino, I set up a simple 
communication protocol that takes in 2 command bytes:
first is [r/~w, len], and the second is [addr]. I also made
the read bytes separate from the write bytes for more space.
I tried building it using array syntax
{% highlight verilog %}
reg [7:0] arr [255:0];
{% endhighlight %}
But I got complaints from ISE when I tried synthesizing because it
tried treating it like ROM. So, I made it a linear vector of bits, and
used the verilog part select operator shown here:
{% highlight verilog %}
reg arr [255 * 8 - 1:0];
val = arr[index +: 8]; //arr[index + 8 - 1:index]
{% endhighlight %}
The tutorial that I learned this from is located
[here](https://embeddedmicro.com/tutorials/mojo/hello-world).

## HCSR04 Module

The HCSR04 has a couple of important properties:

* It uses a 10us trigger to create a blast of sound, it then keeps an
echo pin high for the time it took for that sound to return. This
means that the distance traveled = time * Vsound / 2.
* It has a range of 2 - 400cm.
* It runs on 5V.
* Measurement cycle is recommended to be > 60ms.

One thing that I had to do, was to allow the hcsr04 module to use a
logic clock and a much slower clock (to count ticks). I could build my
own internal clock divider in each hcsr04, but there is no reason to
have multiple dividers, instead I could just use one external that
feeds into each module.

