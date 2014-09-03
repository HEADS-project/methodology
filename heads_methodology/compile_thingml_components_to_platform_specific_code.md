# Compile ThingML components to platform specific code

In order to produce executable code, a ThingML configuration should be defined, where components (both platform-independent and platform-specific) need to be instantiated and connected togather:
```
configuration TestTimerJava {
    instance timer : TimerJava
    instance client : TimerClientJava
    connector client.timer => timer.timer
}
```

###Test your *things* in a standalone mode

This ThingML program can then be compiled (using the standalone editor) to Java. In the compiler Menu, select Java/JASM. This will generate the Java code, wrap it into a Maven project, compile it and run it. In the terminal/console, you should see:

```
tick
0
tock
1
tick
2
tock
3
```

###Wrap your *things* into Kevoree components

Now, to wrap this program into Kevoree, just select, in the compiler menu, Java/Kevoree. This will generate a set of wrappers that exposes the ThingML components (things) as Kevoree components, and will update the pom.xml file to include the necessary Kevoree plugins. In addition, it will also generate a Kevscript file corresponding to the initial configuration of the system, as described in the ThingML configuration:
```
repo "http://repo1.maven.org/maven2"
repo "http://maven.thingml.org"

//include standard Kevoree libraries
include mvn:org.kevoree.library.java:org.kevoree.library.java.javaNode:release
include mvn:org.kevoree.library.java:org.kevoree.library.java.channels:release
include mvn:org.kevoree.library.java:org.kevoree.library.java.ws:release

//include external libraries that may be needed by ThingML components
include mvn:org.thingml:org.thingml.utils:snapshot

//include Kevoree wrappers of ThingML components
include mvn:org.thingml.generated:TestTimerJava:1.0-SNAPSHOT

//create a default Java node
add node0 : JavaNode
set node0.log = "false"
//create a default group to manage the node(s)
add sync : WSGroup
set sync.port/node0 = "9000"
attach node0 sync

//instantiate Kevoree/ThingML components
add node0.TimerClientJava_TestTimerJava_client : KTimerClientJava
add node0.TimerJava_TestTimerJava_timer : KTimerJava

//instantiate Kevoree channels and bind component
add channel_1324969411 : SyncBroadcast
bind node0.TimerClientJava_TestTimerJava_client.timerPort_out channel_1324969411
bind node0.TimerJava_TestTimerJava_timer.timerPort channel_1324969411
add channel_1324969411_re : SyncBroadcast
bind node0.TimerClientJava_TestTimerJava_client.timerPort channel_1324969411_re
bind node0.TimerJava_TestTimerJava_timer.timerPort_out channel_1324969411_re
start sync
start node0
```

###Deploy and adapt with Kevoree, as usual

After you recompile the project (using `mvn clean install`), you can open this KevScripts into the Kevoree editor and deploy it using Kevoree as a normal Java node.
