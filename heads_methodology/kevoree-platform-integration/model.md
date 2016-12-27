# Kevoree model
## Introduction
The meta-model of Kevoree is defined  [here](https://github.com/dukeboard/kevoree/blob/master/kevoree-core/org.kevoree.model/metamodel/org.kevoree.mm)
using [KMF](http://kevoree.org/kmf/)'s modeling language.  


## Requirements
 * A model must be serializable and unserializable to/from a JSON structure. It is useful for the communication of models by the Groups or the publication of models to a Kevoree registry.

## Strategies
### Adding a generator for the targeted platform
You have two choices here:
 - create a KMF generator that targets your language
 - create a model from scratch in the target language

### Transpiling from an existing model
A real life scenario is the development of the C# platform.
No generator exists for this platform, but C# paradigms are very close from Java's one so we had been able to use [IKVM](http://www.ikvm.net/), a tool to convert JARs to DLL.

The whole process is detailed [here](https://github.com/kevoree/kevoree-dotnet-ikvm/wiki).

From our experience, the generated DLL is working really well but we had a hard time figuring out how to integrate it with the isolated contexts needed to load components into a node.

### Kevoree Model's JSON Schema
What matters in the end is that the target platform is able to (de)serialize Kevoree models from (and to) JSON strings.  
The JSON format must comply with this JSON Schema:  

```json
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "additionalProperties": false,
    "type": "object",
    "definitions": {
        "Group": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "metaData": {
                    "type": "array",
                    "items": {"$ref": "Value"}
                },
                "dictionary": {"$ref": "Dictionary"},
                "typeDefinition": {"$ref": "TypeDefinition"},
                "name": {"type": "string"},
                "fragmentDictionary": {
                    "type": "array",
                    "items": {"$ref": "FragmentDictionary"}
                },
                "started": {"type": "boolean"},
                "subNodes": {
                    "type": "array",
                    "items": {"$ref": "ContainerNode"}
                }
            },
            "required": ["started"]
        },
        "Dictionary": {
            "additionalProperties": false,
            "type": "object"
        },
        "FragmentDictionary": {
            "additionalProperties": false,
            "type": "object",
            "properties": {"name": {"type": "string"}}
        },
        "NetworkInfo": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "values": {
                    "type": "array",
                    "items": {"$ref": "Value"}
                },
                "name": {"type": "string"}
            }
        },
        "Channel": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "metaData": {
                    "type": "array",
                    "items": {"$ref": "Value"}
                },
                "dictionary": {"$ref": "Dictionary"},
                "typeDefinition": {"$ref": "TypeDefinition"},
                "bindings": {
                    "type": "array",
                    "items": {"$ref": "MBinding"}
                },
                "name": {"type": "string"},
                "fragmentDictionary": {
                    "type": "array",
                    "items": {"$ref": "FragmentDictionary"}
                },
                "started": {"type": "boolean"}
            },
            "required": ["started"]
        },
        "MBinding": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "hub": {"$ref": "Channel"},
                "port": {"$ref": "Port"}
            }
        },
        "Port": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "bindings": {
                    "type": "array",
                    "items": {"$ref": "MBinding"}
                },
                "name": {"type": "string"},
                "portTypeRef": {"$ref": "PortTypeRef"}
            }
        },
        "PortTypeRef": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "ref": {"$ref": "PortType"},
                "mappings": {"$ref": "PortTypeMapping"},
                "noDependency": {"type": "boolean"},
                "name": {"type": "string"},
                "optional": {"type": "boolean"}
            },
            "required": [
                "optional",
                "noDependency"
            ]
        },
        "DeployUnit": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "requiredLibs": {
                    "type": "array",
                    "items": {"$ref": "DeployUnit"}
                },
                "hashcode": {"type": "string"},
                "name": {"type": "string"},
                "filters": {
                    "type": "array",
                    "items": {"$ref": "Value"}
                },
                "version": {"type": "string"},
                "url": {"type": "string"}
            }
        },
        "DictionaryType": {
            "additionalProperties": false,
            "type": "object"
        },
        "TypeDefinition": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "superTypes": {
                    "type": "array",
                    "items": {"$ref": "TypeDefinition"}
                },
                "metaData": {
                    "type": "array",
                    "items": {"$ref": "Value"}
                },
                "deployUnits": {
                    "type": "array",
                    "items": {"$ref": "DeployUnit"}
                },
                "dictionaryType": {"$ref": "DictionaryType"},
                "name": {"type": "string"},
                "version": {"type": "string"},
                "_abstract": {"type": "boolean"}
            },
            "required": ["_abstract"]
        },
        "Repository": {
            "additionalProperties": false,
            "type": "object",
            "properties": {"url": {"type": "string"}}
        },
        "PortTypeMapping": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "paramTypes": {"type": "string"},
                "beanMethodName": {"type": "string"},
                "serviceMethodName": {"type": "string"}
            }
        },
        "Value": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "name": {"type": "string"},
                "value": {"type": "string"}
            }
        },
        "ComponentInstance": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "metaData": {
                    "type": "array",
                    "items": {"$ref": "Value"}
                },
                "dictionary": {"$ref": "Dictionary"},
                "typeDefinition": {"$ref": "TypeDefinition"},
                "provided": {
                    "type": "array",
                    "items": {"$ref": "Port"}
                },
                "name": {"type": "string"},
                "fragmentDictionary": {
                    "type": "array",
                    "items": {"$ref": "FragmentDictionary"}
                },
                "started": {"type": "boolean"},
                "required": {
                    "type": "array",
                    "items": {"$ref": "Port"}
                }
            },
            "required": ["started"]
        },
        "ContainerNode": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "networkInformation": {
                    "type": "array",
                    "items": {"$ref": "NetworkInfo"}
                },
                "metaData": {
                    "type": "array",
                    "items": {"$ref": "Value"}
                },
                "components": {
                    "type": "array",
                    "items": {"$ref": "ComponentInstance"}
                },
                "dictionary": {"$ref": "Dictionary"},
                "hosts": {
                    "type": "array",
                    "items": {"$ref": "ContainerNode"}
                },
                "typeDefinition": {"$ref": "TypeDefinition"},
                "name": {"type": "string"},
                "host": {"$ref": "ContainerNode"},
                "fragmentDictionary": {
                    "type": "array",
                    "items": {"$ref": "FragmentDictionary"}
                },
                "groups": {
                    "type": "array",
                    "items": {"$ref": "Group"}
                },
                "started": {"type": "boolean"}
            },
            "required": ["started"]
        },
        "Package": {
            "additionalProperties": false,
            "type": "object",
            "properties": {
                "deployUnits": {
                    "type": "array",
                    "items": {"$ref": "DeployUnit"}
                },
                "typeDefinitions": {
                    "type": "array",
                    "items": {"$ref": "TypeDefinition"}
                },
                "name": {"type": "string"},
                "packages": {
                    "type": "array",
                    "items": {"$ref": "Package"}
                }
            }
        },
        "PortType": {
            "additionalProperties": false,
            "type": "object",
            "properties": {"synchrone": {"type": "boolean"}},
            "required": ["synchrone"]
        }
    },
    "properties": {
        "nodes": {
            "type": "array",
            "items": {"$ref": "#/definitions/ContainerNode"}
        },
        "repositories": {
            "type": "array",
            "items": {"$ref": "#/definitions/Repository"}
        },
        "groups": {
            "type": "array",
            "items": {"$ref": "#/definitions/Group"}
        },
        "packages": {
            "type": "array",
            "items": {"$ref": "#/definitions/Package"}
        },
        "mBindings": {
            "type": "array",
            "items": {"$ref": "#/definitions/MBinding"}
        },
        "hubs": {
            "type": "array",
            "items": {"$ref": "#/definitions/Channel"}
        },
        "generated_KMF_ID": {"type": "string"}
    }
}
```
