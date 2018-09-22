#MacHelper

The **MacHelper** is a command line application to execute scenarios requiring user interaction on MacOS.

**This project is under development** and will be reworked and modified during september '18. Different tools working with the MacHelper will be published on this Git:

- An assitant to display html messages to the user
- A splash screen displayed during downloads
- A scenario editor
- A enterprise tool to manage scenarios and for common tasks in companies based on a Microsoft network.


The current version is working and a test package is available for testing:  

<https://github.com/MacAdminTools/MacHelper/releases/tag/v0.8>

The package contains a scenario, an application called Assistant.app (code is available on my GitHub) and assets files. This scenario is a simple demo displaying TextEdit.app, waiting for the user to write "hello" and save the file. If the user writes the correct test, it displays a success message, otherwise it displays a fail message and starts the scenario again.


##Principles

A **scenario** is defined in a Plist file and is executed by the MacHelper. The scenario and the MacHelper can be pushed to the user's device by a MDM.

###Executing the MacHelper

The MacHelper is executed on each startup of MacOS by the LaunchDaemon to verify if there is a scenario to execute. Or can be manually triggered by the MDM. 

###MacHelper UserDefaults

Paths to the scenarios plist are stored in the UserDefaults and are loaded when the MacHelper is executed.  
Information concerning the execution status of the scenarios are also stored. Those information are used : 

* To restore the scenarios in case of interruption of the MacHelper
* To avoid multiple execution of the same scenario

###Scenario data structure

The scenario contains a list of **scenes** defining each process of the scenario. Scenes are linked as a multi-choices scenario. 

Each **scene** contains a list of nodes. Each node contains triggers. Triggers define the **conditions** and **actions** to take during a scene.

Current types of **conditions**:

* Distributed notifications from other applications
* Script exit code (bash, python, applescript)

Current types of **actions**:

* Distributed notifications to other applications
* Script execution (bash, python, applescript)
* Application notification
* Nodes and scenes management
* Create scenes and nodes anchors

###Scenario execution

Anchors are the link between scenes and between nodes. Scenes and nodes will start when their start anchors are active. When a scene or node ends, user can define an action to create an anchor to go to another scene or node.

When the MacHelper starts a scenrio, it looks for initial scenes and nodes. The MacHelper executes them parallelly. 

####Scenes

A scene starts when its start anchors are active or immediatelly if no start anchor is defined. When a scene terminates, the MacHelper looks for initial scenes again and executes them.

####Nodes

A node start to test its conditions when its start anchors are active or immediatelly if no start anchor is defined. When a node terminates, the MacHelper looks for initial nodes again and executes them.

####Triggers

Triggers are used to create conditions/actions groups. The conditions of a trigger are tested every X seconds. When the conditions of a trigger are met, the actions of this trigger are executed. Other triggers of the same node are canceled.

####Conditions
Conditions are tested parallelly every X seconds. Actions are executed if and only if all conditions of a trigger are true.

####Actions

Actions are executed sequentially and parallelly:  

* Each trigger has a list of actions executed parallelly
* Each action contains a list of sub actions executed when the action is terminated and depending on the exit code of the action.
