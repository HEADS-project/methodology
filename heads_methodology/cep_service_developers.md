# Service Developers for CEP
A service developer uses ThingML CEP to develop things which should run on CEP engines. With the HEADS IDE he generates the code for the device. Assume, a platform expert provided a plug-in for the HEADS transformation framework to generate Apama EPL (Event Processing Language) code. Then the service developer can generate Apama EPL code for things modeled in ThingML.

A second approach is to develop a service using Apama EPL and create the service as one query. In a second step use the CEP Recommender (described in deliverable D4.3 of the HEADS project).

## Join and Filter
This example joins two streams (equi-join). Each of these is filtered with a condition. The example demonstrates two aspects. First, filter operations and join operations can be executed on different CEP engines. Second, since the filter operations depend only on one stream, the filter operation can be executed before the join operation. This lowers network traffic since only events relevant for the join have to use network connections.
### Original Query
The following query is executed on a central CEP engine. 
```
	from 
		tEvent in all TemperatureEvent() within 10.0
	join
		pEvent in all PressureEvent() within 10.0
	on
		tEvent.sensorId equals pEvent.sensorId
	where
		tEvent.temperature < 20.0 and pEvent.pressure < 50.0
	select 
		SensorEvent(pEvent.sensorId, pEvent.pressure,
				tEvent.temperature): sensorEvent {
			send sensorEvent to "Output";
	}
```
### Distributed Queries
With the CEP Recommender the query above is split into three parts. Each part can run on its own CEP engine. CEP engine 1 is connected through "CHAN1" with CEP engine 3. CEP engine 2 is connected through "CHAN2" with CEP engine 3.   
Part 1 – Filter temperature events, executed on CEP Engine 1
```
	from tEvent in all TemperatureEvent()
	where tEvent.temperature < 20.0
	select tEvent: tEvent1 {
		send tEvent1 to "CHAN1";
	}
```
Part 2 – Filter pressure events, executed on CEP Engine 2
```
	from pEvent in all PressureEvent()
	where pEvent.pressure < 50.0
	select pEvent : pEvent1 {
		send pEvent1 to "CHAN2";
	}
```
Part 3 – Join operation, executed on CEP Engine 3
```
	monitor.subscribe("CHAN1");
	monitor.subscribe("CHAN2");
	from 
		tEvent in all TemperatureEvent() within 10.0
	join
		pEvent in all PressureEvent() within 10.0
	on
		tEvent.sensorId equals pEvent.sensorId
	select 
		SensorEvent(pEvent.sensorId, pEvent.pressure,
				tEvent.temperature): sensorEvent {
			send sensorEvent to "Output";
	}
```
