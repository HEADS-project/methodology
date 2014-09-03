# Extend Kevoree to deploy code for a new platform

HEADS is not specific to any runtime platform. The platform expert is responsible for adding support for deploying code to the platforms. This is done by creating Kevoree **node types** and implementing the node type API to allow for dynamically deploying and monitoring components on the target platform.

Kevoree currently supports **JVM-based** platforms. ThingML can generate Java code and automatically wrap it into components that can be managed by Kevoree

Kevoree also supports **JavaScript-based** platforms. See here how you can [create your own component](https://github.com/kevoree/kevoree-js#create-your-first-component), built it and deploy it.


> **todo** Inria to complete this part

We will also support [here](http://kevoree.org/practices/level5) the definition of new Node Type

> **!!!** this link just tell how to implement channels, not how to implement nodes!!!!!
