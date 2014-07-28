# Extend the ThingML transformations to compile code for a new platform

When new target languages, operating systems or core libraries need to be supported, the platform expect has to extend the ThingML compilers/transformation. The ThingML compiler will be made modular so that different parts can be reused and extended separately.

ThingML supports for adding annotations on all elements of the language. The platform expert can define specific annotations which are exploited in the code generator in order to support platform specific features.

Examples (to be elaborated): Using Linux Threads (annotation `@fork_linux_thread`, [code generation template](https://github.com/SINTEF-9012/ThingML/blob/master/org.thingml.compilers/src/main/resources/ctemplates/fork.c), [example usage in the linux serial component](https://github.com/SINTEF-9012/ThingML/blob/master/org.thingml.samples/src/main/thingml/core/_linux/serial.thingml))
