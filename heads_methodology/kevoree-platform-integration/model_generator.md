# Model generator
## Introduction

In order to declare publicly a component you have to publish its TypeDefinition and
its DeployUnit to a registry. To do so you have to generate a model for your component.

 - Model generation is handled by platform-specific tools
  - [Maven plugin](https://github.com/dukeboard/kevoree/blob/master/kevoree-tools/org.kevoree.tools.mavenplugin/src/main/java/org/kevoree/tools/mavenplugin/KevGenerateMojo.java) _- java_
- [Grunt task](https://github.com/kevoree/grunt-kevoree-genmodel) _- js_
 - Publication is handled by platform-specific tools
   - [Maven plugin](https://github.com/dukeboard/kevoree/blob/master/kevoree-tools/org.kevoree.tools.mavenplugin/src/main/java/org/kevoree/tools/mavenplugin/KevDeployMojo.java) _- java_
- [Grunt task](https://github.com/kevoree/grunt-kevoree-registry) _- js_
 - A model generator statically analyses code or uses reflection in order to create a Kevoree model composed of a TypeDefinition and its related DeployUnit
 - The created model is then published to the Kevoree registry for a specific **user** in a **namespace** using a specific **name** and **version** for the TypeDefinition & DeployUnit.


## Existing implementations
### Java
A maven plugin ([kevoree-maven-plugin](https://github.com/dukeboard/kevoree/tree/master/kevoree-tools/org.kevoree.tools.mavenplugin)) is in charge of publishing collectively a component to a maven repository and to a Kevoree registry.  
The code analysis is done by reflection (mostly by annotations scanning).

### Javascript
For the JavaScript platform, the model generation is made by a [Grunt task](https://www.npmjs.com/package/grunt-kevoree-genmodel) that will reflect on the Node.js module code. The reflection is mostly done by reading the provided properties of the class. The properties that have a meaning in Kevoree are prefixed using **naming conventions**:
 - **tdef_version**: for the TypeDefinition version
 - **dic_XXX**: for Dictionary Attribute
 - **in_XXX**: for input port
 - **out_XXX**: for output port

The TypeDefinition is created by reading those properties.  
The DeployUnit is created by reading the `package.json` in order to know how to download the module from the **npm registry**.  
Publication can then be handled, on demand, using another [Grunt task](https://www.npmjs.com/package/grunt-kevoree-registry).

### C&#35;
Their is no integrated tool to do all in once in c# yet.

The process is split in two steps:
 1. publish the package to a nuget registry
 2. use the C# [Kevoree Model Generator](https://github.com/kevoree/kevoree-dotnet-model-generator) to publish the package to a Kevoree registry
