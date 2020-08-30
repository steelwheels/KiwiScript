# Preference
The *Preference* class is used access system preference values.

## Global variables
The singleton object is defined for Preference class.

|Variable       |Class      | Description                   |
|:---           |:---       |:---                           |
|`Preference`   |Preference |Singleton object of the class  |

## `system` preference
The preference of system software such as OS, base application.

This is a list of properties in the preference:
|Name       |Type       |Description                        |
|:---       |:---       |:---                               |
|`version`  |String     |The version of the application     |
|`logLevel` |[LogLevel](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/LogLevel.md) | Log level for debugging|

Here is examples to acceess property.
````
let version_string = Preference.system.version ;
Preference.system.logLevel = LogLevel.error ;
````

## `terminal` preference
The preference of terminal attributes.

This is a list of properties in the preference:
|Name               |Type       |Description                |
|:---               |:---       |:---                       |
|foregroundColor    |[Color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Color.md)  |The integer value to present foreground color |
|backgoundColor     |[Color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Color.md) |The integer value to present background color  |

## `shell` preference
*This preference is exist only in interractive mode in shell.* This has properties for shell operation.

This is a list of properties in the preference:
|Name       |Type       |Description                        |
|:---       |:---       |:---                               |
|`prompt`   |Function   |The function to generate prompt string |

Here is examples to acceess property.
````
Preference.shell.prompt = function() {
    return "JSH" ;
}
````

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
