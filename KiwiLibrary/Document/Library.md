# Library

## Built-in modules
The module is written by Swift and built in `jsrun` command.
The auto loaded class/object is always loaded before executing the user script.
On the other hand, the other libraries are loaded by
[require](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/RequireFunc.md) statement.

Here is the example to load `JSON` module
````
var JSON = require('JSON') ;
````
This is a table of built-in modules.

|Module name  |Auto load    |Top class/object name | Document             |
|:---         |:---         |:---            |:---|
|-            |Yes          |`Process`       |[Process Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/ProcessClass.md)|
|-            |Yes          |`console`       |[Console Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/ConsoleClass.md) |
|-            |Yes          |`File`          |[File Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/FileClass.md)  |
|`JSON`       |No           |`JSON`          |[JSON Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/JSONClass.md)  |

## Standard Library
The library is written by JavaScript and distributed within the JSTool package.
They will be loaded by [require](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/RequireFunc.md) statement.

Here is the example to load primitive classes for graphics.
````
var graph = require('Graphics/Primitive') ;
````
|Library name | Document                 |
|:---         |:---                      |
|`Graphics/Primitive` | [Graphics Primitive Class ](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/GraphicsPrimitive.md) 

## Related link
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/tree/master/KiwiLibrary): Top level document
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.