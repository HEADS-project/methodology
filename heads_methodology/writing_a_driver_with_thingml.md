# Writing a driver with ThingML

This section details how to implement a driver for ThingML. A driver basically wrap an existing piece of code (in Java, C, C++, ...) and expose it as a ThingML API, which can then be seamlessly used by service designers, with no need to cope with low-level details related to Java, C, C++, ...

We will use a timer as a running example, that we will wrap in C and also in Java.

## Defining the interface

A ThingML driver is a plain ThingML component (or *thing*). In this respect, it is usually recommended to first describe the interface of a component, and then implement it, possibly for different platforms. This is realized in two steps.

First, declate a thing fragment containing all the messages that are relevant:



## Calling native code from ThingML


## Advanced Example: XXX

The previous example

## Calling ThingML code from native code

### in C/C++

### in Java
