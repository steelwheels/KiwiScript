# Kiwi Standard Library
The built-in class, function, data types for JavaScript.

## Enum types
* [AccessType](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/AccessType.md) : Type of the file access.
* [Alignment](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Alignment.md): Kind of alignment of components.
* [AnumationState](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/AnimationState.md): State of animation
* [Authorize](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Authorize.md): Kind of authorization for access security.
* [Axis](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Axis.md): Kind of direction to place GUI components.
* [Distribution](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Distribution.md) : Kind of the distribution of objects
* [FileType](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/FileType.md) : Type of the file. File, directory, ...
* [FontSize](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/FontSize.md) : Size of font
* [LogLevel](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/LogLevel.md) : Level to filtering the log messages.

## Primitive Types
* [Point](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Primitive/Point.md): 2D point data presented as (x, y).
* [Size](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Primitive/Size.md): 2D object size data presented as (width. height)
* [Rect](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Primitive/Rect.md): 2D rectangle data presented as (width. height)

## Functions
* character: [asciiCodeName](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/AsciiCodeName.md): Get ascii code name for given character
* [Array1D](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Array1D.md): Functions  to operate 1D array data.
* [Array2D](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Array2D.md): Functions  to operate 2D array data.
* Contacts: Functions for contact database.   [setupContacts](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/SetupContacts.md)  and [setupContactTable](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/SetupContactTable.md)
* [exit](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Exit.md): Exit the caller process with exit code
* [Graphics](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Graphics.md): Data structures and functions for graphics.
* [launch](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Run.md): Launch the macOS application with/without the documents.
* [openPanel, savePabel](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Panel.md): *For macOS only.* Function to display panel to open/close the file.
* [run](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Run.md): Load user script and execute on the thread
* [sleep](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Sleep.md): Suspend execution for an interval of time (seconds)
* [String](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/String.md): String operation
* [Suspend](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Suspend.md): Suspend to wait the signal from the other process.
* [system](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/System.md): Execute shell command
* [thread](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Thread.md): Generate thread to execute JavaScript.
* [Type checking](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/TypeChecks.md): Functions to check object types such as `isNull`, `isBoolean`, `isNumber`, etc...
* [Objet checking](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/ObjectChecks.md): Functions to check object context such as `isEmptyString`, `isEmptyObject`, etc... 
* [valueType](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/TypeGetter.md): Get the data type of given parameter.

## Constructor function
* [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md): Allocate URL object.

## Singleton Objects
There are some pre-defined objects. They are instance of built-in classes:
* [Char](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Char.md): The character class
* [Color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Color.md): Define and allocate color object
* [console](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Console.md): The object to print messages into the terminal.
* [Curses](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md): The object to control terminal.
* [debug](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Debug.md): The class for debugging. This is used to print log into log window.
* [EscapeCode](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/EscapeCode.md): The class to operate escape code
Generate escape sequence string to be passed to terminal.
* [Math](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Math.md): The singleton object which has class methods for mathematical operation and such as `PI`, `sin()`, `cos()`.
* [Readline](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Readline.md): The singleton object which manages the console input.
* [Symbol](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Symbol.md): The singleton object which manages the built-in symbol image.

## Classes
### Preference
* [Preference](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Preference.md): Access preference value of this application and system software.

### Process control
Create and control processes and threads.
* [Process](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Process.md): The object presents the process. This is allocated by process control functions such as [system](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/System.md) function.
* [Thread](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Thread.md): The object presents the thread. This is allocated by thread control functions such as [thread](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Thread.md) function.
* [Semaphore](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Semaphore.md): Semaphore
* [Environment](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Environment.md): Operate environment variables such as `PWD`, `TMPDIR` and etc.

### File management
* [FileManager](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/FileManager.md): The singleton object to open, read, write and close the text file.
* [ScriptManager](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ScriptManager.md): The singleton object to read built-in script file.
* [File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md): The file object to access it's contents.
* [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md): The object to present the pipe. This will be used as a parameter for the other method.
* [JSON](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/JSON.md): The object to operate JSON file.
* [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md): Data representation of URL

### Terminal
* [Curses](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md): CUI management on the terminal.
* [FontManager](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/FontManager.md): The singleton object to manage fonts.

### Graphics
* [BitmapContext](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/BitmapContext.md): The class for 2D bitmap drawing
* [GraphicsContext](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/GraphicsContext.md): The class for 2D graphics drawing
* [Image class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Image.md): The class for image object.

### Data
* [Collection](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Collection.md): An ordered collection of data items
* [Table](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Table.md): NxM data table class.
* [Text](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Text.md): The data structure to present structured text. The cast function [toText](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/TypeCast.md) function is used to cast object to Text.
* [String](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/String.md): Methods to operate/edit string. such as `maxLengthOfStrings()`.
* [ValueStorage](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueStorage.md): Key-value storage which can be loaded from/stored into the file

### Database
* [Contacts](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Contacts.md): The contact database
* [ContactRecord](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ContactRecord.md): The contact database

### Built-in JavaScript class
* [Turtle class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/Turtle.md): Support [turtle graphics](https://en.wikipedia.org/wiki/Turtle_graphics). It uses [GraphicsContext](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Components/Graphics2D.md).

## Data format
There are definitions of formats of data objects:
* [Primite values](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Format/primitive-values.md)

## Related links
* [KiwiLibrary Framework](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/README.md): The framework contains this library.
