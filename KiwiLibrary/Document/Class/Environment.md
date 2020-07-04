# Environment Class
The *Environment* class is used to set and get environment variables.

## Global variables
The singleton object is defined for Environment class.

|Variable       |Class             | Description                   |
|:---           |:---              |:---                           |
|`Environment`  |Environment       |Singleton object of the class  |

## Pre-defined environment variables
Following variables are defined before executing script.

|Variable name  |Description                                             |
|:---           |:---                                                   |
|`CLICOLOR`, `CLICOLOR_FORCE` |The flag to use color in the terminal. The [JSTerminal](https://github.com/steelwheels/JSTerminal/blob/master/Documents/UsersManual.md) could not support terminal functions such as `isatty`. For more details, see [Bug & Restrictions](https://github.com/steelwheels/JSTerminal/blob/master/Documents/restrictions.md). |
|`COLUMNS`      |Number of columns in the terminal. It presents the digit value. |
|`LINES`        |Number of lines in the terminal. It presents the digit value. |
|`PWD`          |Path of the current working directory                  |
|`TERM`         |Terminal type. The default value is `xterm-16color`    |
|`TMPDIR`       |Path of the temporary directory                        |

## `set` method
Set environent variable. The name of the variable and it's value are must have string type.
````
Environment.set(name: String , value: String) ;
````

### Parameter(s)
|Parameter      |Type   |Description                            |
|:---           |:---   |:---                                   |
|name           |String |Name of the variable to be set         |
|value          |String |Value of the variable to be set |

### Return value
none

## `get` method
Get value of environment variable by it's name.
````
let value = Environment.get(name: String) -> String
````

### Parameter(s)
|Parameter      |Type   |Description                            |
|:---           |:---   |:---                                   |
|name           |String |Name of the variable to get            |

### Return value
The string when the value is exist.
If the variable is NOT found, this value will be `null`.

## `currentDirectory` property
Property for the URL of the current directory.
This is read only property.
````
let url = Environment.currentDirectory ;
````

### Return value
The [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) object.

## `temporaryDirectory` property
Property for the URL of the temporary directory.
This is read only property.
````
let url = Environment.temporaryDirectory ;
````

### Return value
The [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) object.

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
