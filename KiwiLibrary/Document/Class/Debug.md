# Debug class
The *Debug* class is used to print text to console.

## Global variable
The singleton object is defined for Debug class.

|Variable   |Class    | Description                     |
|:---       |:---     |:---                             |
|debug      |Debug    |Singleton object of Debug class  |

## `log` method
Print log message to log window/terminal.
The newline code will be appended to the given message.
````
debug.log(<level>, <message>) ;
````
The message is *filtered* by log window/terminal. The message will be print when the _preference log level_ (See [preference log level](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Preference.md)) is weaker than the level parameter.

You can check the current preference level.
````
let level = Preference.system.logLevel ;
````

#### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|level        |[LogLevel](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/LogLevel.md) |The level of source message|
|message      |String |Log message string             |

### Return value
none

## References
* [Console class](Console.md): The `Console` class
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
