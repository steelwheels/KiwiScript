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
* [Color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Color.md) : Basic color definitions

## Functions
* [exit](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Exit.md): Exit the process.
* [isNull, isUndefined, isNumber, ...](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/TypeChecks.md): Functions to check object types.
* [Open/Save Panel](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Panel.md): *For macOS only.* Function to display panel to select input/output function.

## Objects
There are some pre-defined objects. They are instance of built-in classes:
* `console`: An instance of [Console class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Console.md)
* `Curses`: An instance of [Curses class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md).
You can allocate [Window](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Window.md) object by this instance.

## Class objects
Class objects to operate objects.
* [`Process`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Process.md): This has interface to control the main process such as `exit` method.
* [`Math`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Math.md): Mathematical function and constants such as `sin()`, `cos()`, `PI`.
* [`File`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md): The object to access the text file.
*  [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md): The object to present the pipe. This will be used as a parameter for the other method.
*  [Shell](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Shell.md): The object to execute the shell script.
* [JSON](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/JSON.md): The object to operate JSON file.

## Classes
* [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md): Data representation of URL. The constructor function is also defined.
* [process](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Process.md): The instance of the `Process` class.
* [Window](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Window.md): CLI window allocated by [Curses](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md) object.
* [`Database`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Database.md): This has the interface to access database in the component.

## Related links
* [KiwiLibrary Framework](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/README.md): The framework contains this library.
