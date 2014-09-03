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

To do so one should adopt/wrap a native C/C++ library (wrapped library) in such a away that the library (wrapping library) can call callbacks which execute some of the ThingML generated code. We suggest the following mechanism to call the generated code in ThingML from the native library. However, there are other ways to achieve the goal as well. The explanation below is given using C++, but the same approach can be used in C as well.

1) Create a type definition for a callback and structure which holds the callback to call from the wrapping library. The type definition and structure should look as follows:
```
typedef void (*pthingMLCallback)(void* _instance, ...);

struct ThingMLCallback {
	pthingMLCallback fn_callback;
	void* instance;

	ThingMLCallback(pthingMLCallback _callback, void* _instance):
		fn_callback(_callback),
		instance(_instance){
	};
};
```
As one may notice, we use the ellipsis ("..."). Thus, the wrapping library can call a function with any number of arguments following `_instance`. The `_instance` argument is used by ThingML to identify a thing. Therefore, `_instance` is an internal concern of ThingML. One should just make sure that a reference to a thing (`_instance`) is passed together with a reference to the callback. ThingMLCallback has two arguments, i.e. a reference `_callback` to the callback and void reference `_instance` to the thing, which is passed as the first argument when the callback is called.

2) The wrapping library that calls the callback should hold a reference to an instance of ThingMLCallback. For example:
```
class BinarySensor {
	private:
		ThingMLCallback* valueUpdatedCallback;
	public:
		...
		//set ThingML callback
		void setValueUpdatedCallback(ThingMLCallback* _callback){valueUpdatedCallback = _callback;};
		
		//function is called by a native library
		void valueupdate(int value);
		...
}
```

3) Call the callback from the wrapping libarary as follows.
```
void BinarySensor::valueupdate(int value){
	this->valueUpdatedCallback->fn_callback(this->valueUpdatedCallback->instance, value);
}
```

Note, that the `valueupdate(int value)` function is called by the native (wrapped) library.


4) Define a thing which uses the wrapping library. The wrapping library calls the callback `function value_change_binarysensor_callback()` defined in the thing `ZWaveBinarySensor`.

```
import "thingml.thingml"

datatype BinarySensor
@c_type "BinarySensor*";

thing ZWaveBinarySensor 
@c_header "
#include <stdlib.h>
#include <cstdarg>
#include \"BinarySensor.h\"

using namespace TinyOpenZWaveApi;
"
{
    property bs : BinarySensor
    
    provided port bsport {
    	receives initialize
    }
    
	//these are two internal ports shoud be bound together
	provided port bsportintsend {
		sends status
	}
	
	required port bsportintrecv {
		receives status
	}
	

    function value_change_binarysensor_callback()
    @c_prototype "void value_change_binarysensor_callback(void *_instance, ...)"
    @c_instance_var_name "(ZWaveBinarySensor_Instance *) _instance"
    do
		'va_list arguments;'
        'va_start(arguments, _instance);'
        'int state = va_arg(arguments, int);'
    	'va_end(arguments);'
    	bsportintsend!status('state')
    end
	
	function init_binarysensor() do
        print "ZwaveBinarySensor: initializing ... \n"
        'ThingMLCallback* value_changed = new ThingMLCallback(value_change_binarysensor_callback, _instance);'
        bs = 'new BinarySensor();'
		''&bs&'->setValueUpdatedCallback(value_changed);'
	end

	function getState() : Integer do
		return ''&bs&'->getCurrentValue()'
	end
    
   
    statechart behavior init Start {
 
    
    	state Start {
    		on entry do
				print "ZwaveBinarySensor: waiting for initialize command ...\n"
			end
    		transition->Ready
    		event bsport?initialize
			action do
    			init_binarysensor()
    		end
    	}
				
		state Ready {
			on entry do
				print "ZwaveBinarySensor: ready ...\n"
			end
			
			internal event e : bsportintrecv?status
			action do
				// here may go some code
			end
		}

    }
}
```

Note, we use the ThingML capability to bland the ThingML code and sources which are native to some platform (in this case C++). The C++ code is enclosed by the single quotes. 

We have defined the callback `value_change_binarysensor_callback` with the signature that corresponds to the `typedef` from point 1. Make sure that this callback in ThingML should be annotated with `@c_prototype` and `@c_instance_var_name`. The annotation `@c_prototype` instructs ThingML to generate a function with the signature given in the double quotes, `@c_instance_var_name` casts `_instance` to the proper type. These annotations are required to perform a call of the callback on the right thing (it is the `ZWaveBinarySensor` thing in our case) 

Further, we create an instance of ThingMLCallback that holds references to the callback `value_change_binarysensor_callback` and `ZWaveBinarySensor` thing (`_instance`), i.e. `ThingMLCallback* value_changed = new ThingMLCallback(value_change_binarysensor_callback, _instance);`. Subsequently, `value_changed` is passed to the wrapping library, i.e. `''&bs&'->setValueUpdatedCallback(value_changed);'`. Now if the native (wrapped) library calls the function which we have implemented in the wrrapping library, i.e. `void valueupdate(int)`(see the point  2), the wrapper calls the callback `function value_change_binarysensor_callback()`. Finnally, we can extract a value passed to the callback using `va_list` and `va_arg` in `function value_change_binarysensor_callback()` as well as we can use any ThingML instructions. 


#### in Java

In Java, the easiest way to call ThingML code from a plain Java class is to

1. Make the Thing extend a Java interface. This is realized by annotating the thing: `thing MyThing @java_interface "my.package.MyInterface"`. The methods defined in this Java interface should be implemented in the thing. As ThingML functions are private by default, the function corresponding to the Java methods to be implemented need to be annotated: `function myFunction()@override "true"`. This function needs to have the exact same signature as the one defined in the Java interface.
2. In the external Java class, import the Java interface, define a pointer to that interface (a reference or a list), and call the methods of that interface in the Java class
3. Implement a registration mechanism in the Java class, so that I can actually call the class generated from the thing (and extending the interface). This can typically be done by defining an extra argument (typed by the interface) in the constructor. The plain Java class can then be created from the thing as follows: `'new my.package.MyClass(this)'`. The Java class can then hold a reference to the thingml object (`this`) and call methods on it.
