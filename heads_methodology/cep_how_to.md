# How to develop CEP Queries within the HEADS IDE
## How to use the Apama Studio
### Components of Apama Studio
There are four components in Apama Studio for CEP development: The EPL Editor and debug environment, the Query Builder, the Event Modeler, and the Dashboard Builder. 
 
- Developing EPL with Apama Studio: EPL Editor

To get started with EPL inside the Apama Studio use the tutorial on EPL monitor scripts. In Apama Studio open the Welcome page, go to the Tutorials section. There are three tutorials. The last one with the title 'Developing an Application with MonitorScript' is the most important one. It explains the Apama Event Programming Language (EPL), called "MonitorScript". A Cheat Sheet guides you through this tutorial. 

In addition there are several samples introducing topics of Apama. In Apama Studio open the Welcome page, go to the Samples section. These six samples can be imported into an Eclipse workspace as Apama projects. From the Apama Workbench perspective you can launch these samples, one at a time. The Readme files suggest small exercises to modify these samples. The source of the samples is the folder 'demos' in the Apama installation. The folder 'samples' contains more in-depth examples for components of Apama and the connection with other products like Universal Messaging or Terracotta BigMemory.

Steps to perform for a sample:

* Import project into workspace
* Explore files in the Apama Workbench perspective. Toggle on the 'Show All Folders' button in the toolbar of the 'Workbench Project View'.
* Launch the sample with the 'Launch Control Panel'. This starts a correlator (Apama CEP runtime process) listening on port localhost:15903 (default). 
In addition a dashboard viewer is started in a separate window and events are sent to the correlator. 

There are three perspectives in Apama Studio, Apama Developer, Apama Runtime, and Apama Workbench. Apama Developer is similar to the Java perspective in JDT. Apama Workbench is a simplified combination of Apama Developer and Apama Runtime. It is tailored to work on a single Apama project. This can be selected in the Workbench Project View.

- Using the Query Builder in Apama Studio

The Query Builder is a combined graphical and textual editor for Apama Queries. These queries are new with Apama 5.3 and they allow a purely  descriptive way to define stream queries. These queries are capable of large time windows.
 
- Event Modeler
This component helps to model state machines in EPL. This is not the focus inside the HEADS IDE and therefore not described in detail. Refer to the Apama documentation which is included in the Eclipse Help.  

- Dashboard Builder
The dashboard builder is used for the development of dashboard to visualize stream data. This is not part of the HEADS IDE and not in the focus of HEADS.  

## How to use the CEP Recommender
- support for model-based partitioning approach

- According to steps in D4.2 (reference?). Repeat the manual steps.

-- Service developer develops query logic (EPL text, Apama query language is not implemented yet) This is the main input.
-- Platform expert adds statistical data: event rates, event sizes, selectivity of filters, etc.
-- Platform expert provides nodes info: CPU capacity of the nodes, CEP capabilities of the nodes.

- Steps done automatically: model transformations

- Output: list of model instances, each containing a partitioned query, i.e. a set of simpler queries which have together the same functionality than the input query. Such a set of queries can be deployed to the nodes. 

- Future developments for the rest of the project