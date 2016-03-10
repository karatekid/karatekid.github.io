---
layout: post
title: Summary of "Test-Driven Development for Embedded C" by James W. Grenning
category: writeup
image: tdd_embedded_c/cover.jpg
---

## Preface

## Test-Driven Development for Embedded C by James W. Grenning

### Initial Thoughts

### Book Layout

### Chapter 1: Test-Driven Development

The first chapter is a fairly straight forward introduction that fleshes out
what test driven development is all about. At its most basic, TDD is all about
making meaningful incremental changes that are always validated by tests. This
process can be amply summarized by the quip "Red, Green, Refactor". Thus showing
that you right a test for new behavior, once the test is passing then the test
can be used to ensure any stylistic changes don't modify behavior. These
incremental changes allow for quicker and more reliable development while also
constantly pushing code to be more modular. The figures below highlight the
differences between typical "Debug Later" programming and TDD.

{% include figure.html url='/assets/img/tdd_embedded_c/debug_later.jpg' caption='Debug Later Programming'%}

{% include figure.html url='/assets/img/tdd_embedded_c/tdd_workflow.jpg' caption='Test Driven Development'%}

It's quite easy to see how much time is saved when finding the bug. Since you
don't have to do any mental context switching to get back up to speed with the
codebase debug time can go by much quicker.

### Getting Started

#### Chapter 2: Test-Driving Tools & Conventions

In Chapter 2, James introduces the 2 test harnesses that he covers:
[Unity](http://www.throwtheswitch.org/unity) and
[CPPUTest](http://cpputest.github.io/). These are fairly similar harnesses, one
is written in C++, which allows it to automatically add tests to the harness.

Both harnesses provide a similar interface, exposing __test groups__ that can be
used to group similar tests together into test fixtures. These fixtures are used
to group commonalities, such as setup and teardown functionalities. Both
harnesses also provide ways to check for equality and the like. Below are some
examples of using these two libraries similar to what the author provided.

##### CppUTest Example

{% highlight c++ %}
TEST_GROUP(thing) {
    const char * expected_val;
    int expected_num;
    void setup() {
        // Do Stuff
    }
    void teardown() {
        // Do more stuff
    }
    void helper_fxn(int n) {
        expected_num = n;
    }
};

TEST(thing, DontDoMuch) {
    helper_fxn(5);
    LONGS_EQUAL(expected_num, 5);
}
{% endhighlight %}

You can see that the group seems to be a macro that generates a class.

##### Unity Example

{% highlight c %}
// Test.c

TEST_GROUP(thing);

static const char * expected_val;
static int expected_num;

TEST_SETUP(thing) {
    // Do stuff
}
TEST_TEAR_DOWN(thing) {
    // Do more stuff
}
static void helper_fxn(int n) {
    expected_num = n;
}

TEST(thing, DontDoMuch) {
    helper_fxn(5);
    TEST_ASSERT_EQUAL(expected_num, 5); 
}

// TestRunner.c

TEST_GROUP_RUNNER(thing) {
    RUN_TEST_CASE(thing, DontDoMuch);
}
{% endhighlight %}

In the unity example, you need to manually add each test to a runner or use a
script. Also, all methods and variables are usually just made as static to have
file scope, since c doesn't have the concept of classes.

Both test harnesses follow these 4 phases of TDD:

1. Setup
2. Exercise
3. Verify
4. Cleanup

#### Chapter 3: Starting a C Module

Tests are much easier to write when code is more modular. To make single
instance modules you can simply provide methods that are defined in a header
file and indirectly act on `static` variables in the `.c` file, kind of like
`private` class variables in C++. For modules that have more than one instance
you can use a `typedef` of a forward declared struct. For example, you can place
the following in your header file.
{% highlight c %}
typedef struct ObjectStruct * Object;
{% endhighlight %}
Note that when you have hidden data like this, you should always have `create`
and `destroy` methods to handle setting up and tearing down these data
structures.

Test lists are very useful when developing new functionality since they
basically demonstrate the requirements. An example for a LED driver is given:

* All LEDs are off after the driver is initialized
* A single LED can be turned on
* Turn on all LEDs

The trick to making C modules that operate on hardware easily testable is to
initialize them with a pointer to the region of memory that they should operate
on. Since most embedded modules work by using MMIO to communicate with the
hardware, we can trick them during testing by redirecting them to a region of
memory which we control. This methodology is known as __dependency injection__.

Using this knowledge we can begin development, but hold your horses. When
developing, try to only write code when there is a test for it. More
specifically, follow Bob Martin's 3 laws of TDD shown below:

##### 3 Laws of TDD - Bob Martin
1. Don't write code unless it makes a failing test pass.
2. Don't more more of a test than is sufficient to fail.
3. Don't write more code than is sufficient to pass one failing test.

This methodology may seem counterintuitive at first, but it allows you to create
a well-defined vise around your code, guaranteeing behavior and showing very
definite incremental progress which can be very satisfying. It may even seem
absurd, since you are encouraged to fake results at first to get things passing,
then add more tests. You tend to stop faking things once it is easier to do it
for real. This is known as __DTSTTCPW__ or "Do the Simplest Thing that Could
Possibly Work".

Also keep thse tests small & focused, trying to test only 1
facet of your code. Don't be afraid to reuse initialization, you've guaranteed
that it works, now you can build another test using it and testing something
else. Follow the TDD state machine during development.

{% include figure.html url='/assets/img/tdd_embedded_c/tdd_state_machine.jpg' caption='TDD State Machine'%}

Also try to keep your tests following the __F.I.R.S.T__ methodology:

* F - Fast
* I - Isolated
* R - Repeatable
* S - Self-verifying
* T - Timely

#### Chapter 4: Testing your Way to Done

Chapter 4 is basically a walkthrough TDD, showing a detailed example of what the
various steps are. Here are a couple of tidbits I gleaned from reading through
it. When refactoring don't break anything, copy / paste, don't cut / paste. Once
everything is in place then substitute your change. Once tests are passing,
remove the old code and if tests still pass you're all set! During this section
James makes use of a __stub__, a test version of a production function that
gives us insight into what was passed into that function, for example we can get
information on what was logged, etc. Also note that once an error get's
introduced during TDD just undo to debug, since you just added the faulty code
you can very quickly see what went wrong.

#### Chapter 5: Embedded TDD Strategy

Chapter 5 is the most relevant chapter to embedded systems development and
discusses how to keep the software and hardware in working order. James
recognizes that testing on hardware can be expensive in time and other factors.
Since you usually don't have your target hardware for some time, it's usually a
good idea to get an evaluation board for your processor, this reduces the number
of unknowns and can allow you to start working on hardware before you get the
eventual target.

Dual-targeting is an important concept when working with TDD on embedded
systems. You want to be able to run most modules on the target platform, your
evaluation board, and your development setup. You'll be doing a lot of upfront
verification on the development system, but you obviously want to ensure that
everything works on the other platforms. Dual-targeting allows us to keep this
need forefront in our minds durnig development.

During development follow the embedded TDD cycle:

1. The standard TDD micro cycle - every save
2. Compiler Compatibility check - every commit
3. Run unit tests on eval board - every day
4. Run unit tests on target board - every day
5. Run manual acceptance tests on target board - hardware or hardware code
   change

{% include figure.html url='/assets/img/tdd_embedded_c/embedded_tdd_cycle.jpg' caption='Embedded TDD Cycle'%}

When setting up a system for separate targets you could take a couple of
different approaches. You could use: 

* conditional compilation (ugly, hard to understand)
* platform specific header files (use `#define` to define functions differently)
* platform specific implementation directories (the __best__ answer). This is an
  __adapter pattern__.

Automated hardware tests should find any language construct differences, memory
issues, and misunderstanding of hardware. They must also be automatically
verified.

The manual acceptance tests should have some sort of command terminal to
communicate with the hardware to trigger tests and get the expected result. You
can also have long / short tests, running them with varying frequencies. You can
also use external instruments to test, such as a function generator.

#### Chapter 6: Excuses & Problems with TDD

Chapter 6 reads like a FAQ or troubleshooting guide for TDD enumerating various
peoples' problems with TDD in the embedded world and then addressing them. I'll
highlight a couple of the interesting ones.

Single-step and hardware debugging are very slow try to avoid it, guess what TDD
helps avoid it.

What about testing after development (TAD)? TDD is more about than development,
while TAD is all about testing, doesn't have as immediate of feedback, and
doesn't get as much coverage.

TDD doesn't find all bugs. While this is true, it does find a lot of them and
really helps during development. You obviously still need these test types:

* integration
* acceptance (fulfill requirements)
* exploratory
* load & performance (explore limits)

TDD causes long build times. Well, try modularizing your builds.

TDD is too memory intensive on HW. Use a small harness, break into multiple
runners.

Create a big visible chart __BVC__ to track various factors of your code e.g.
flash size, ram, etc.
{% include figure.html url='/assets/img/tdd_embedded_c/bvc.jpg' caption='Big Visible Chart'%}

Isn't simulating hardware difficult? It is, that's why we mock things and merely
simulate the interaction, not the entire system.

### Testing Modules with Collaborators

> A __collaborator__ isn't someone that you work with, it's any function, data, or
module that is outside the code under test __CUT__ that the CUT depends upon.

#### Chapter 7: Introducing Test Doubles

As the excerpt above states, the segments of code that we test often have
__collaborators__ and we must deal with those collaborators properly when we
test code. We can impersonate these collaborators with __test doubles__. These
impersonate the collaborators and allow us to send special values to the CUT and
ensure that the collaborators are getting passed the proper input. To be able to
make these test doubles our design has to have well defined interfaces between
modules, without them it's hard to know what we're trying to impersonate. An
illustration of the place for test doubles is given below:

{% include figure.html url='/assets/img/tdd_embedded_c/test_dependency.jpg' caption='Typical Dependencies of CUT'%}
{% include figure.html url='/assets/img/tdd_embedded_c/test_doubles.jpg' caption='Impersonating Collaborators with Test Doubles'%}

The best times to use test doubles are when you want to:

* Gain Hardware Independence
* Inject Difficult to Produce / Rare Inputs
* Speed up Collaborators
* Stop Depending on Volatile Collaborators (e.g. Clocks)
* Work with something that isn't fully Developed

To create these test doubles you generally have 4 options:

1. Linker Substitution: You replace the collaborator for the whole executable.
   For example, you'd use this for a hardware test double.
2. Function * Substitution: You replace the collaborator for only some of the
   test cases.
3. Preprocessor Substitution: You can override certain functions with the
   preprocesor, e.g. changing `malloc`, this changes the actual code though and
   is recommended against.
4. Combine link-time and function * substitution: The linker initializes a
   function * to `NULL`, but each test sets the function * to what they need.

There are various types of test doubles, here are a few:

| Name | Description |
| ---- | ----------- |
| Test Dummy | Satisfy the compiler / linker, but never used |
| Exploding Fake | Dummy + makes test fail if called |
| Test Stub | Dummy + return a value described by the test case |
| Test Spy | Stub + capture parameters passed in so test can verify |
| Mock Object | Verifies functions called, call order, and parameters passed, while returning specific values to the CUT |
| Fake Object | Partial implementation, to return different values depending on the input |

#### Chapter 8: Spying on Production Code

#### Chapter 9: Runtime-Bound Test Doubles

#### Chapter 10: The Mock Object

### Design & Continuous Improvement

#### Chapter 11: SOLID, Flexible, & Testable Designs

#### Chapter 12: Refactoring

#### Chapter 13: Adding Tests to Legacy Code

#### Chapter 14: Test Patterns & Antipatterns

### Closing Takeaways for my Future Work

### List of Possibly useful references that they mentioned

* {% include book_reference.html name='art_designing_embedded' %}
* {% include book_reference.html name='tdd_by_example' %}
* {% include book_reference.html name='refactoring' %}
* {% include book_reference.html name='xunit_test_patterns' %}
* {% include book_reference.html name='program_w_abstract_dt' %}
* {% include book_reference.html name='agile_sw_dev' %}
* {% include book_reference.html name='agile_in_flash' %}
* {% include book_reference.html name='pragmatic_programmer' %}
* {% include book_reference.html name='taming_embedded_tiger' %}
* {% include book_reference.html name='working_w_legacy_code' %}
* {% include book_reference.html name='endo_testing' %}
* {% include book_reference.html name='agile_sw_dev' %}
* {% include book_reference.html name='data_abstraction_hierarchy' %}
* {% include book_reference.html name='oo_sw_construction' %}
* [Extreme Programming Rules of Simple Design](http://c2.com/xp/XpSimplicityRules.html)
* {% include book_reference.html name='refactoring' %}
* {% include book_reference.html name='clean_code' %}
* {% include book_reference.html name='scaling_agile_dev' %}
* {% include book_reference.html name='xp_explained' %}
