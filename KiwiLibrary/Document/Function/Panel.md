# Panel functions
This document describes about panel functions.

# Functions
## `openPanel` function
````
var url = openPanel(title, isDirectory, [extensions]) ;
````
### Parameters
|Name     |Type     |Description              |
|:---     |:---     |:---                     |
|title    |string   |Title of the panel       |
|isDirectory |bool  |*true*: Select directory, *false*: Select file|
|extensions |Array of string | Array of file extensions |

### Return value
|Type     |Description              |
|:---     |:---                     |
|URL      |Selected file or directory |
|null     |Use does not select the file or directory  |

## `savePanel` function
````
var didsaved = savePanel(title, directory, callback) ;
````
### Parameters
|Name     |Type     |Description              |
|:---     |:---     |:---                     |
|title    |string   |Title of the panel       |
|directory | string or null| Path for default directory. If this value is null, it means no default directory.|
|callback |(URL) -> void   |Callback function which is called when the user select the file to save|

### Return value
|Type     |Description              |
|:---     |:---                     |
|bool     |*true*:File is saved, *false*: is not saved |

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

