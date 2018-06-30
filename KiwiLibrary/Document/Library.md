# Library

## Global data types, functions
Following data types and functions are defined at global scope.
* [Data types](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/GlobalType.md)
* [Functions](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/GlobalFunction.md)

## Built-in modules
The module is written by native language (Swift).
The auto loaded class/object can be always used in the user script.
On the other hand, the other libraries are loaded by
[require](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/RequireFunc.md) statement.

Here is the example to load `JSON` module
````
var JSON = require('JSON') ;
````
This is a table of built-in modules.

|Module name  |Auto load    |Top class/object name | Document             |
|:---         |:---         |:---            |:---|
|-            |Yes          |`console`       |[Console Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/ConsoleClass.md) |
|-            |Yes          |`Curses`       |[Curses Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/CursesClass.md) |
|-            |Yes          |`File`          |[File Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/FileClass.md)  |
|-            |Yes          |`Pipe`          |[Pipe Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/PipeClass.md)  |
|`Shell`      |No           |`Shell`          |[Shell Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/ShellClass.md)  |
|`JSON`       |No           |`JSON`          |[JSON Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/JSONClass.md)  |
|`Contact`     |No           |`Contact`      |[Contact Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/ContactClass.md)  |

## Built-in Classes
Following classes are supported:

|Class name   |Target               |Description          |
|:---         |:---                 |:---                 |
|[URL class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/URLClass.md) | macOS, iOS | Operate URL |

## Built-in Functions
|Class name   |Target               |Description          |
|:---         |:---                 |:---                 |
|[Panel functions](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/PanelFunc.md) | macOS            |Operate panel such as open panel and save panel|

## Standard Library
The library is written by JavaScript and distributed within the JSTool package.
They will be loaded by [require](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/RequireFunc.md) statement.

Here is the example to load primitive classes for graphics.
````
var graph = require('Graphics/Primitive') ;
````
|Library name | Description                 |
|:---         |:---                      |
|`Math/Math` |[Primitive functions for mathematics](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Math.md)|
|`Graphics/Primitive`|[Graphics Primitive Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/GraphicsPrimitive.md) |

## Related link
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/tree/master/KiwiLibrary): Top level document
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
