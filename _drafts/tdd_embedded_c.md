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

#### Chapter 5: Embedded TDD Strategy

#### Chapter 6: Excuses & Problems with TDD

### Testing Modules with Collaborators

#### Chapter 7: Introducing Test Doubles

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
