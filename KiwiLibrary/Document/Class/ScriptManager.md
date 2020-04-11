# Script Manager Class
The *ScriptManager* class is used to read built-in script.

## Global variables
Singleton object for ScriptManager class

|Variable   |Class  | Description                     |
|:---       |:---   |:---                             |
|ScriptManager  |ScriptManager   |Singleton object of Script manager |

## `scriptNames` method
Returns an array of name of file names (strings)
````
let names = ScriptManager.scriptNames() ;
````

### Parameter(s)
none

### Return value
Array of string to present script names.

## `search` method
Returns URL of given script file.
````
let url = ScriptManager.search(filename) ;
````

### Parameter(s)
|Parameter      |Type   |Description                    |
|:---           |:---   |:---                           |
|file           |String |Name of the script. Use a string which is returned by `scriptNames` method. |

### Return value
The [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) object when the file is find.
If the file is not found, this value will be `null`.

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
