# Platform Experts for CEP
In order to deploy code generated from ThingML CEP on Apama CEP engines, we need to have Apama EPL as a supported platform in the HEADS transformation framework.
A platform expert with Apama CEP knowledge is needed for writing a plug-in for this HEADS transformation framework in order to support Apama EPL as a target platform.
This plug-in transforms ThingML CEP into Apama EPL code. It is based on the mapping between ThingML CEP and Apama EPL described in detail in the deliverable D2.3 of the HEADS project.
The main parts of this mapping are:
- Event type <-> Message
- Channel <-> Port
- Monitor <-> Thing
- Stream query <-> Stream query
 