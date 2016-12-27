# Extend Kevoree to support a new communication channel

To support different communication protocols, HEADS relies on the definition of communication channels. Kevoree allows defining channel types which can then be deployed between components. The channel types can wrap low level protocols (such as binary on a serial link) as well as high level protocols (such as emails or skype calls).

A channel in Kevoree is implemented as follows:

```java
@ChannelType(version = 1, description = "First attempt at creating a channel")
public class MyFirstChannel implements ChannelDispatch {

    @KevoreeInject
    private ChannelContext channelContext;

    @Override
    public void dispatch(final String payload, final Callback callback) {
        for (Port p : this.channelContext.getLocalPorts()) {
            p.send(payload, callback);
        }
    }
}
```

This naive implementation basically implements a direct call to the local ports. However, instead of a simple `p.send` it is possible to use third-party APIs, for example publishing a message on a MQTT topic.

The channel context gives you access to the model. The dispatch method is called automatically when a message is received by one of the channel fragment. You must have in mind that this channel is instantiated for any node on which bound components are deployed.

You can follow this tutorial on how to [make your own Kevoree channel](http://kevoree.org/practices/level5/) for more details about channels.
