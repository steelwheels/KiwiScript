# Kiwi Standard Library
The built-in class, function, data types for JavaScript.

## Target
There are some use cases to use JavaScript program in the application:

|Target     |Description                              |
|:---       |:---                                     |
|`Terminal` |The script is executed as shell script. The [jsrun](https://github.com/steelwheels/JSTools/blob/master/Document/jsrun-man.md) command execute the JavaScript in this mode.   |
|`Window`   |One or more scripts are used to control log for the Cocoa application. The [Amber Script](https://github.com/steelwheels/Amber/blob/master/Document/AmberLanguage.md) uses this mode.|
|`Operation`  |The script is executed as the thread. It is executed as an [Operation](https://developer.apple.com/documentation/foundation/operation) in the queue.|

## Enum types
* [Alignment](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Alignment.md): Kind of alignment of components.
* [Authorize](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Authorize.md): Kind of authorization for access security.
* [Axis](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Axis.md): Kind of direction to place GUI components.
* [Color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Color.md) : Basic color definitions
* [Distribution](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Distribution.md) : Kind of the distribution of objects
* [TypeID](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/TypeID.md): Type identifier of JavaScript values. The [type checks](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/TypeChecks.md) page contains how to get the identifier.

## Primitive Types
* [Point](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Primitive/Point.md): 2D point data presented as (x, y).
* [Size](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Primitive/Size.md): 2D object size data presented as (width. height)
* [Rect](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Primitive/Rect.md): 2D rectangle data presented as (width. height)

## Functions
* [exit](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Exit.md): Exit the process.
* [isNull, isUndefined, isNumber, ...](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/TypeChecks.md): Functions to check object types.
* [sin, cos, ...](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Math.md): Mathematical function and constants such as `sin()`, `cos()`, `PI`.
* [Open/Save Panel](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Panel.md): *For macOS only.* Function to display panel to select input/output function.

## Objects
There are some pre-defined objects. They are instance of built-in classes:
* `console`: An instance of [Console class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Console.md)
* `Curses`: An instance of [Curses class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md).
You can allocate [Window](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Window.md) object by this instance.
* `Image`: An instance of [Image class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Image.md).

## Class objects
Class objects to operate objects.
* [`Process`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Process.md): This has interface to control the main process such as `exit` method.
* [`File`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md): The object to access the text file.
*  [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md): The object to present the pipe. This will be used as a parameter for the other method.
*  [Shell](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Shell.md): The object to execute the shell script.
* [JSON](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/JSON.md): The object to operate JSON file.

## Classes
* [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md): Data representation of URL. The constructor function is also defined.
* [process](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Process.md): The instance of the `Process` class.
* [operation](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Operation.md): The engine to execute JavaScript on the thread.
* [operation queue](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md): The queue to execute the `operation` instance.
* [Window](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Window.md): CLI window allocated by [Curses](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md) object.
* [`Database`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Database.md): This has the interface to access database in the component.

## Built-in JavaScript Library
* [`SpriteAction`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/SpriteAction.md): The parameters to decide sprite node action.
* [`SpriteStatus`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/SpriteStatus.md): The parameters to present sprite node status.
* [`SpriteCondition`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/SpriteCondition.md): The parameters to present the simulation conditions.

## Related links
* [KiwiLibrary Framework](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/README.md): The framework contains this library.
