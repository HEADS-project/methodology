# Deploy platform specific code using Kevoree

After the platform specific binaries have been compiled, Kevoree should be used to deploy, initialize and monitor the application.

# Java environment
## The Kevoree Maven Plugin

The Kevoree Maven plugin extracts the Component-Model from the annotations placed in your code, and stores it into a Kevoree Model packed along with the compiled class files.
Also, for the ease of use, the Kevoree Maven plugin embeds a Kevoree runner. This runner launches a Kevoree runtime using a KevScript file. This file is supposed to be `src/main/resources/kevs/main.kevs` in the project. Alternatively, you can specify the location of the KevScript file you want to use in the configuration of the plugin.
You can also specify the name of the node you want to launch.

```
<plugin>
	<groupId>org.kevoree.tools</groupId>
	<artifactId>org.kevoree.tools.mavenplugin</artifactId>
	<version>${kevoree.version}</version>
	<executions>
		<execution>
			<goals>
				<goal>generate</goal>
			</goals>
		</execution>
	</executions>
	<configuration>
		<nodename>MyNode</nodename>
		<model>src/main/kevs/main.kevs</model>
	</configuration>
</plugin>
```

### Available actions

Mainly the Kevoree maven plugin is automatically executed at compile time in order to put additional informations in the JAR. *(Mainly model fragment of currently developed type definitions)*.

Additionally, user can execute directly the root kevScript file refered in the configuration using the following command:

`mvn kev:run`

This will execute Kevoree directly in the maven environement.  

# Javascript
Kevoree-js has 2 different Grunt tasks to process and deploy your project:
- **grunt-kevoree-genmodel**: parses your sources in order to create the corresponding Kevoree model
- **grunt-kevoree**: starts a Kevoree JavaScript runtime using `kevs/main.kevs` KevScript file and `node0` as a default node name.  

Those Grunt tasks must be defined in a `Gruntfile.js` at the root of your project.

```js
module.exports = function (grunt) {

    grunt.initConfig({
    	// grunt-kevoree-genmodel
    	kevoree_genmodel: {
            main: {
                options: {
                    quiet: false,
                    verbose: true
                }
            }
        },
    	
    	// grunt-kevoree
    	kevoree: {
    	    options: {
    	    	name: 'node0'
    	    },
            run: {
                kevscript: 'kevs/main.kevs'
            }
        }
    });
};
```

You can get more details on their own repos [`grunt-kevoree`](https://github.com/kevoree/kevoree-js/blob/master/tools/grunt-kevoree/README.md) and [`grunt-kevoree-genmodel`](https://github.com/kevoree/kevoree-js/blob/master/tools/grunt-kevoree-genmodel/README.md)

# C++
> todo
