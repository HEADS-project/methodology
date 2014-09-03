# Extend Kevoree to support a new communication channel

To support different communication protocols, HEADS relies on the definition of communication channels. Kevoree allows defining channel types which can then be deployed between components. The channel types can wrap low level protocols (such as binary on a serial link) as well as high level protocols (such as emails or skype calls).

A channel in Kevoree is implemented as follows:

```java
@ChannelType
@Library(name = "Java")
public class MyFirstChannel implements ChannelDispatch {

    @KevoreeInject
    ChannelContext channelContext;

    @Override
    public void dispatch(final Object payload, final Callback callback) {
        for (Port p : channelContext.getLocalPorts()) {
            p.call(payload, callback);
        }
    }
}
```

This naive implementation basically implements a direct call. However, instead of a simple `p.call` it is possible to call third-party API for example publishing a message on a MQTT topic.

The channel context gives you access to the model. The dispatch method is called automatically when a message is received by one of the channel fragment. You must have in mind that this channel is instantiated for any node on which bound component are deployed.

You can follow this tutorial on how to [make your own Kevoree channel](http://kevoree.org/practices/level5/) for more details about channels.
