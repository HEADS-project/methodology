# Create libraries to support platform specific features / library / component

In the case that the target language is supported by an existing transformation, support for platform specific features can be added by creating platform specific libraries in ThingML. These platform specific libraries integrated ThingML structures and code together with code written in the target language and specific to the target platform.

This section details how to implement a driver for ThingML. A driver basically wraps an existing piece of code (in Java, C, C++, ...) and exposes it as a ThingML API, which can then be seamlessly used by service designers, with no need to cope with low-level details related to Java, C, C++, ...

We will use a simple random integer generator as a running example, that we will wrap in C and also in Java.

> Generating random integers could certainly be implemented directly in ThingML, however, as all programming languages already provide facilities for random generation, this would have been like... re-inventing the wheel. **Better wrap what already works!**

### Defining the interface

A ThingML driver is a plain ThingML component (or *thing*). In this respect, it is usually recommended to first describe the interface of a component, and then implement it, possibly for different platforms. This is realized in two steps.

First, declare a thing fragment containing all the messages that are relevant:

```thingml
thing fragment RandomMsg{
	message request();
	message answer(v: Integer);
}
```

> As ThingML is asynchronous, **the request and the answer should be defined in two distinct messages**. In synchronous Java, this would have been a single method like `public int random()`, blocking the caller until the random is computed.

Then declare a second thing fragment, which includes the former one, and group messages into a port:

```thingml
thing fragment Random includes RandomMsg{
	provided port random {
		receives request
		sends answer
	}
}
```

> ThingML would allow defining only one thing fragment containing both the message declarations and the port. However, if a thing want to use a timer, it will need to include the timer messages. **Splitting message and port declarations favors a better reuse**:

```
thing fragment RandomUser includes RandomMsg{
	required port random {
		sends request
		receives answer
	}
}
```

### Calling native code from ThingML

Calling native code, for any target language, is realized as follows:

- for pure native statement: they should be place between simple quotes, such as `'srand(time(NULL));`
- for mixed code, typically if a call to a native function should be passed with parameters coming from ThingML, it is realized as follows: `'' & rn & '.nextInt(Short.MAX_VALUE + 1)'`, where rn is a ThingML variable (holding a Java type).

The implementation (wrapping) of the random facility is given below, for C and for Java.

#### calling C/C++ code

```thingml
import "../random.thingml"

thing RandomLinux includes Random
@c_headers "#include <time.h>"
{
    statechart Random init start {
    	state start {
    		on entry 'srand(time(NULL));'
    		transition ->waiting
    	}
        state waiting {
          internal waiting
            event random?request
            action random!answer('rand()')
        }
    }
}
```

First, the `@c_headers "#include <time.h>"` annotation ensure the `RandomLinux` thing includes the proper C headers. When the thing is initialized, it will initialize the random sequence by calling the C `srand(time(NULL))` function and will then wait for request and serve random integers by calling the C `rand` function.

#### calling Java code

```thingml
import "../random.thingml"

datatype JavaRandom
@java_type "java.util.Random";

thing RandomJava includes Random
{
	property rn : JavaRandom = 'new java.util.Random()'
    statechart Random init waiting {
        state waiting {
          internal waiting
            event random?request
            action random!answer('' & rn & '.nextInt(Short.MAX_VALUE + 1)')
        }
    }
}
```

First, a datatype is created, backed by the `java.util.Random` class. This datatype is initialized in the `RandomJava` thing as follows: `property rn : JavaRandom = 'new java.util.Random()'`.

> The call to `new` is actually plain Java code and not a ThingML keyword, as it is placed between single quotes.

Similarly to the C thing, this thing will then wait for request and serve random integers using `'' & rn & '.nextInt(Short.MAX_VALUE + 1)'`.

This statement mixes ThingML code: `rn` is a ThingML property (though it is mapped to a Java type), while `.nextInt(Short.MAX_VALUE + 1)` is plain Java code.

> ThingML Integer are actually 2-byte long and thus cannot be mapped to Java int. They are rather mapped on Java short. The `Short.MAX_VALUE + 1` expression ensures the java int produced by `nextInt`does not overflow the ThingML Integer (*i.e.*, a Java short).

### Calling ThingML code from native code

The previous example simply called native code from a ThingML program. In more advanced cases, it is however useful to be able to call ThingML code from a native API (typically when wrapping a library relying on callbacks).

#### in C/C++

#### in Java
