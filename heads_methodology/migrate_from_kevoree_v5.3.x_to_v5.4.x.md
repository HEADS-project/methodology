# Migrate from Kevoree v5.3.x to v5.4.x

We have rewritten the Kevoree Registry in 2016 in order to strenghten our _database_ and to add _user authentication_ and a _namespace_ concept.
Those changes impacted all the different platforms. They had so much impact that v5.4.x **is no longer** backward-compatible with v5.3.x and below.  

### Kevoree Registry: users & namespaces

In order to give more control over what is published on the registry, we have added __users__ and __namespaces__ to it.  
This means that from now on, valid credentials are mandatory to publish models to the registry. To get those credentials, an account has to be created on the registry,  [here](https://registry.kevoree.org/#/register).  
Creating a new user will automatically create a namespace with the **same name** so you can directly publish Kevoree models using those credentials.  
But it also allows you to create new namespaces (if not already created), from the [registry website](https://registry.kevoree.org/#/ns) using the **New namespace** button when authenticated.  

### One configuration file for all platforms

The Kevoree registry connection information and user crendentials can now be stored independently from the Kevoree platform you are using.
It has to be located in `$HOME/.kevoree` in a JSON file named `config.json`:

```json
{
  "user": {
    "login": "YOUR_NAME_HERE",
    "password": "YOUR_PASSWORD_HERE"
  },
  "registry": {
    "host": "registry.kevoree.org",
    "port": 443,
    "ssl": true,
    "oauth": {
      "client_secret": "kevoree_registryapp_secret",
      "client_id": "kevoree_registryapp"
    }
  }
}
```
> For security reasons, this file should have limited read access on your operating system

This file will be read by the KevScript interpreter in order to connect to the registry and resolve TypeDefinitions & DeployUnits.  
If you want to connect to a third-party registry, just modify the content of the `$HOME/.kevoree/config.json` file according to your registry location and credentials.  

### The new KevScript resolver

We have introduced two new keywords in the language in order to solve DeployUnit resolutions by the KevScript interpreter:
 - LATEST
 - RELEASE  
 
TypeDefinition versions can now be specified using whether an **integer** or **LATEST** which will indicate to the KevScript interpret which version the service developers expect. For the DeployUnits, the possibilities are whether **LATEST** or **RELEASE**. Refer to the table at the end of this <a href="https://github.com/kevoree/kevoree-js/wiki/Migrate-to-new-registry-(v5.4.0-SNAPSHOT-and-above)#what-does-it-change-for-the-kevscript" target="_blank">wiki page</a> for more details about those keywords.

### Platform specific details

You can read more about the migration for a specific platform here:
 - <a href="https://github.com/dukeboard/kevoree/wiki/Migrate-to-new-registry-(v5.4.0-SNAPSHOT-and-above)" target="_blank">Java platform migration</a>
 - <a href="https://github.com/kevoree/kevoree-js/wiki/Migrate-to-new-registry-(v5.4.0-SNAPSHOT-and-above)" target="_blank">JavaScript platform migration</a>
