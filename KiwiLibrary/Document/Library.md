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
* [Type check functions](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/TypeCheck.md): Functions to check object types.
* [Open/Save Panel](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Panel.md): *For macOS only.* Function to display panel to select input/output function.

## Objects
There are some pre-defined objects. They are instance of built-in classes:
* `console`: An instance of [Console class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Console.md)
* `Curses`: An instance of [Curses class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md).
You can allocate [Window](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Window.md) object by this instance.

## Class objects
Class objects to operate objects.
* `Process`: The class object of [Process class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Process.md). This has interface to control the main process such as `exit` method.
* `File`: The class object of [File class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md).
* `Pipe`: The class object of [Pipe class ](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md)
* `Shell`: The class object of [Shell class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Shell.md)
* `JSON`: The class object of [JSON class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/JSON.md)

## Classes
* [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md): Data representation of URL. The constructor function is also defined.
* [process](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Process.md): The instance of the `Process` class.
* [Window](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Window.md): CLI window allocated by [Curses](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md) object.

## Related links
* [KiwiLibrary Framework](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/README.md): The framework contains this library.
