# Model HD-Service logic with ThingML components

The service developer uses ThingML to define the components of the HD-Service and implement the logic of those components.

State machines are a common formalism to express reactive behavior that needs to react on some events, correlate events, and produce some new events. A state machine-based programming language, and ThingML in particular, is thus a good candidate to implement Kevoree components and write the logic that orchestrates the different ports of this component.

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

Second, a simple client:
```
thing TimerClient includes TimerMsgs
{

	required port timer
    {
		receives timer_timeout
		sends timer_start, timer_cancel
	}

    statechart Default init Tick {

        property counter : Integer = 0

        state Tick {
            on entry
            do
                timer!timer_start(1000)
            end

            transition tock -> Tick
            event timer?timer_timeout
            action do
                print("tick")
                print(counter)
                counter = counter + 1
            end
        }

    }

}
```

This simple, platform-independent service basically outputs a "tick" every second. This is realized by starting a timer when entering the `Tick` state. On timeout, a `timer_timeout` message is received, triggering the print of "tick", before it re-enters the `Tick` state.
