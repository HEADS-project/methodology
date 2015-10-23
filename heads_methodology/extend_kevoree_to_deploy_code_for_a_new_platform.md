# Extend Kevoree to deploy code for a new platform

HEADS is not specific to any runtime platform. The platform expert is responsible for adding support to deploy code to a new platform.  

Kevoree currently supports 2 platforms:
 - **JVM-based**  
   ThingML can generate Java code and automatically wrap it into components that can be managed by Kevoree
 - **JavaScript-based**  
   See here how you can [create your own component](https://github.com/kevoree/kevoree-js#create-your-first-component), built it and deploy it

In order to add a support for a new platform in Kevoree, instructions on how to integrate it are available [here](kevoree-platform-integration/index.md)
