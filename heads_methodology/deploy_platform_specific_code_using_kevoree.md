# Deploy platform specific code using Kevoree

After the platform specific binaries have been compiled, Kevoree should be used to deploy, initialize and monitor the application.

# Java environment
## The Kevoree Maven Plugin

The Kevoree Maven plugin extracts the Component-Model from the annotations placed in your code, and stores it into a Kevoree Model packed along with the compiled class files.
Also, for the ease of use, the Kevoree Maven plugin embeds a Kevoree runner. This runner launches a Kevoree runtime using a KevScript file. This file is supposed to be `src/main/kevs/main.kevs` in the project. Alternatively, you can specify the location of the KevScript file you want to use in the configuration of the plugin.
You can also specify the name of the node you want to launch.

```
<project>
  <!-- classic pom.xml file content ... (this hasnt changed) -->
  <build>
    <plugins>
      <plugin>
        <groupId>org.kevoree.tools</groupId>
        <artifactId>org.kevoree.tools.mavenplugin</artifactId>
        <!-- ${kevoree.version} must be v5.4.0-SNAPSHOT or greater -->
        <version>${kevoree.version}</version>
        <executions>
          <execution>
            <goals>
              <goal>generate</goal>
              <goal>deploy</goal>
            </goals>
          </execution>
        </executions>
        <configuration>
          <!-- your Kevoree registry namespace -->
          <namespace>mynamespace</namespace>
          <nodeName>anotherName</nodeName>
          <kevscript>src/main/kevs/anotherModel.kevs</kevscript>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
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
	require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    kevoree_genmodel: { main: {} },
    kevoree: { main: {} },
    kevoree_registry: {
      src: 'kevlib.json'
    }
  });

  grunt.registerTask('default', 'build');
  grunt.registerTask('build', 'kevoree_genmodel');
  grunt.registerTask('kev', ['build', 'kevoree']);
  grunt.registerTask('publish', ['build', 'kevoree_registry']);
};
```

You can get more details on their own repos [`grunt-kevoree`](https://github.com/kevoree/grunt-kevoree) and [`grunt-kevoree-genmodel`](https://github.com/kevoree/grunt-kevoree-genmodel)
