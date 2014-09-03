# Extend Kevoree to deploy code for a new platform

HEADS is not specific to any runtime platform. The platform expert is responsible for adding support for deploying code to the platforms. This is done by creating Kevoree **node types** and implementing the node type API to allow for dynamically deploying and monitoring components on the target platform.

We currently support **JVM-based** platform. See here how you can [create your own component](http://kevoree.github.io/kevoree-book/making_a_component/README.html), build it and deploy it.

We currently support **JavaScript-based** platform. See here how you can [create your own component](https://github.com/kevoree/kevoree-js#create-your-first-component), built it and deploy it.
https://github.com/kevoree/kevoree-js

We will also support [here](http://kevoree.org/practices/level5) the definition of new Node Type

> **todo** Inria to complete this part
