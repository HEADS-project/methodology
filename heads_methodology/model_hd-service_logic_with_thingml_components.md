# Model HD-Service logic with ThingML components

The service developer uses ThingML to define the components of the HD-Service and implement the logic of those components.

State machines are a common formalism to express reactive behavior that needs to react on some events, correlate events, and produce some new events. A state machine-based programming language, and ThingML in particular, is thus a good candidate to implement Kevoree components and write the logic that orchestrates the different ports of this component.

## Define interfaces: 

Let's consider a simple ThingML program made of two things, basically involving message to deal with a timer:

```
thing fragment TimerMsgs {
	// Start the Timer
	message timer_start(delay : Integer);
	// Cancel the Timer
	message timer_cancel();
	// Notification that the timer has expired
	message timer_timeout();
}
```

First, a timer:
```
thing fragment Timer includes TimerMsgs
{
	provided port timer
    {
		sends timer_timeout
		receives timer_start, timer_cancel
	}
}
```
## Implement the logic using state machines and action languages

A simple client using the timer could be:
```
thing HelloTimer includes TimerMsgs {

    required port timer {
		receives timer_timeout
		sends timer_start, timer_cancel
    }

    readonly property period : Integer = 1000
    property counter : Integer = 0
	
	statechart behavior init Init {
	
		state Init {
			on entry do
				timer!timer_start(period)
			end
			
			transition -> Init //this will loop on the Init state, and start a new timer
			event timer?timer_timeout
			action do
                		print "hello "
				print counter
                		print "\n"
                		counter = counter + 1
			end
		}
	}
}
```

This simple, platform-independent service basically outputs a "hello n" every second. This is realized by starting a timer when entering the `Init` state. On timeout, a `timer_timeout` message is received, triggering the prints, before it re-enters the `Init` state.

Basically, this would produce the following outputs:
```
hello 0
hello 1
hello 2
```

Alternatively, the previous example can be refactored in the following way to keep the state machine clean:
```
thing HelloTimer includes TimerMsgs {

    required port timer {
		receives timer_timeout
		sends timer_start, timer_cancel
    }

    readonly property period : Integer = 1000
    property counter : Integer = 0

    function printHello() do
        print "hello "
	print counter
        print "\n"
        counter = counter + 1
    end
	
    statechart behavior init Init {
	
        state Init {
	    on entry do
	        timer!timer_start(period)
	    end
			
	    transition -> Init //this will loop on the Init state, and start a new timer
	    event timer?timer_timeout
	    action printHello()
	}
    }
}
```

More generally the general syntax for a function is:
```
function myFunction(param1 : ParamType1, param2 : ParamType2) : ReturnType do
    ...
end
```

Like in most programming languages, functions are particularly useful to encapsulate code that is called from multiple places, to avoid duplication.

> The HEADS action and expression language is fairly aligned with major programming languages such as Java, JavaScript or C: 
- variable definitions and affectations `var i : Integer = 0`,
- algebraic (`+`, `-`, etc) and boolean operators (`and` and `or`)
- control structures `if (true) do ... end else do ... end`, `while(true) do ... end`
- `print "hello"` and `error "alert!"`
- function calls `myFunction(0, 1)`

> In addition to the "normal" statements common with those language, HEADS provides:
- send a message `myPort!myMessage()`, `myPort!myMessage2(a, b, 0)` for asynchronous message passing between components

## Implement advanced logic with Complex Event Processing

The HEADS modelling language has been extended with CEP concepts (See D2.2 for more details). CEP complements state machines and provides more powerful abstractions to handle streams of events, for example to compute the average of the values provided by a sensor on a given time window, or to when some behavior should be triggered when two events happen "at the same time". While this can be expressed with state machines, this typically implies instantiating timers and arrays (to manage time windows), managing different interleaving, etc, *i.e.* this generates accidental complexity. Those CEP concepts are mapped to the ones provided by [ReactiveX](http://reactivex.io/).

### Join

The [join operator](http://reactivex.io/documentation/operators/join.html) "*combines items emitted by two Observables whenever an item from one Observable is emitted during a time window defined according to an item emitted by the other Observable*". See the figure below (taken from ReactiveX documentation) to get an idea of how it works.

![Join](http://reactivex.io/documentation/operators/images/join.c.png)

This is expressed in the HEADS modelling language using this syntax:
```
stream simpleJoin @TTL "100" do //@TTL1 and @TTL2 can be used to provide different TTLs (time windows)
    from [e1 : receivePort?m1 & e2 : receivePort?m2 -> cep1()]
    action sendPort!cep1()
end
```

Whenever a message `m1` and a message `m2` are received within 100 ms, it will produce a `cep1` message.

The same query expressed directly using the ReactiveX API would require about 15 lines of code (in Java or JavaScript). The declarative syntax of the HEADS modelling language for CEP concepts hence greatly simplifies the expression of CEP queries. Moreover, the stream expressed above can be compiled to Java or JavaScript with no modification, the compiler taking care of mapping to the Java and JS version of the ReactiveX APIs.

### Merge

## Debugging

Traces are a common way of understanding the execution of a program, identify and solve bugs. Traces can automatically be added to trace:

- the initialization of instances, with values for all attributes. Those traces appear in light blue in the figure below.
- the execution of the state machine (which states are being entered/exited, which transition are triggered, etc). Those traces appear in yellow in the figure below.
- the emission/reception of messages on ports. Those traces appear in green in the figure below.
- the affectation of variables. Those traces appear in magenta/purple in the figure below.
- the execution of functions. Those traces appear in dark blue (not present in the figure below).

Using `@debug "true"` and `@debug "false"` the service developer can finely filter the elements he wants to trace.

![Traces](traces.png)
