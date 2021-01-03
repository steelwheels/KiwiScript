# Kiwi Standard Library
The built-in class, function, data types for JavaScript.

## Enum types
* [AccessType](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/AccessType.md) : Type of the file access.
* [Alignment](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Alignment.md): Kind of alignment of components.
* [Authorize](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Authorize.md): Kind of authorization for access security.
* [Axis](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Axis.md): Kind of direction to place GUI components.
* [Color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Color.md) : Basic color definitions
* [Distribution](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Distribution.md) : Kind of the distribution of objects
* [FileType](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/FileType.md) : Type of the file. File, directory, ...
* [FontSize](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/FontSize.md) : Size of font 
* [LogLevel](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/LogLevel.md) : Level to filtering the log messages.
* [TypeID](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/TypeID.md): Type identifier of JavaScript values. The [type checks](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/TypeChecks.md) page contains how to get the identifier.

## Primitive Types
* [Point](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Primitive/Point.md): 2D point data presented as (x, y).
* [Size](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Primitive/Size.md): 2D object size data presented as (width. height)
* [Rect](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Primitive/Rect.md): 2D rectangle data presented as (width. height)

## Functions
* character: [asciiCodeName](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/AsciiCodeName.md): Get ascii code name for given character
* [exit](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Exit.md): Exit the caller process with exit code
* [Graphics](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Graphics.md): Functions for graphics.
* [launch](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Run.md): Launch the macOS application with/without the documents.
* [Open/Save Panel](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Panel.md): *For macOS only.* Function to display panel to select input/output function.
* [run](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Run.md): Load user script and execute on the thread
* [sleep](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Sleep.md): Suspend execution for an interval of time (seconds)
* [String](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/String.md): String operation 
* [Suspend](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Suspend.md): Suspend to wait the signal from the other process.
* [system](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/System.md): Execute shell command
* [thread](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Thread.md): Generate thread to execute JavaScript.
* [Type checking](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/TypeChecks.md): Functions to check object types such as `isNull`

## Shell programming support
* [commandHistory](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/CommandHistory.md): Get the command strings which they had been executed.

## Objects
There are some pre-defined objects. They are instance of built-in classes:
* [Char class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Char.md): The character class
* [Console class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Console.md): The object to print messages into the terminal.
* [Debug class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Debug.md): The class for debugging. This is used to print log into log window.
* [EscapeCode class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/EscapeCode.md): The class to operate escape code
Generate escape sequence string to be passed to terminal.
* [Image class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Image.md): The class for image object.
* [Math](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Math.md): The singleton object which has class methods for mathematical operation and such as `PI`, `sin()`, `cos()`.

## Classes
### Preference
* [Preference](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Preference.md): Access preference value of this application and system software.

### Process control
Create and control processes and threads.
* [Process](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Process.md): The object presents the process. This is allocated by process control functions such as [system](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/System.md) function.
* [Thread](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Thread.md): The object presents the thread. This is allocated by thread control functions such as [thread](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Thread.md) function.
* [Operation](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Operation.md): The engine to execute JavaScript on the thread.
* [OperationQueue](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md): The queue to execute the `operation` instance.
* [Environment](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Environment.md): Operate environment variables such as `PWD`, `TMPDIR` and etc.

### File management
* [FileManager](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/FileManager.md): The singleton object to open, read, write and close the text file.
* [ScriptManager](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ScriptManager.md): The singleton object to read built-in script file.
* [File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md): The file object to access it's contents.
*  [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md): The object to present the pipe. This will be used as a parameter for the other method.
* [JSON](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/JSON.md): The object to operate JSON file.
* [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md): Data representation of URL

### Terminal
* [Curses](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md): CUI management on the terminal.
* [FontManager](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/FontManager.md): The singleton object to manage fonts.

### Graphics
* [`SpriteAction`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/SpriteAction.md): The parameters to decide sprite node action.
* [`SpriteStatus`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/SpriteStatus.md): The parameters to present sprite node status.
* [`SpriteCondition`](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/SpriteCondition.md): The parameters to present the simulation conditions.

## Related links
* [KiwiLibrary Framework](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/README.md): The framework contains this library.
