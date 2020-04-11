# File Manager Class
The *FileManager* class is used to allocate *File* class.
The File is used to read and/or write the file.

## Global variables
Following global variables are defined when this class is imported.

|Variable   |Class  | Description                     |
|:---       |:---   |:---                             |
|FileManager  |FileManager   |Singleton object of File class   |
|stdin      |File | Standard input            |
|stdout     |File | Standard output           |
|stderr     |File | Standard error output     |

## `isReadable` class method
Returns a Boolean value that indicates whether the file at the given URL is readable or not.
````
FileManager.isReadable(file: URL) -> Bool
````

### Parameter(s)
|Parameter      |Type   |Description                    |
|:---           |:---   |:---                           |
|file           |[URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) |URL of the file to check      |

### Return
The value is `true` when the given file is readable.

## `isWritable` class method
Returns a Boolean value that indicates whether the file at the given URL is writable or not.
````
FileManager.isWritable(file: URL) -> Bool
````

### Parameter(s)
|Parameter      |Type   |Description                    |
|:---           |:---   |:---                           |
|file           |[URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) |URL of the file to check      |

### Return
The value is `true` when the given file is writable.

## `isExecutable` class method
Returns a Boolean value that indicates whether the file at the given URL is executable or not.
````
FileManager.isExecutable(file: URL) -> Bool
````

### Parameter(s)
|Parameter      |Type   |Description                    |
|:---           |:---   |:---                           |
|file           |[URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) |URL of the file to check      |

### Return
The value is `true` when the given file is executable.

## `isDeletable` class method
Returns a boolean value that indicates whether the file at the given URL is deletable or not.
````
FileManager.isDeletable(file: URL) -> Bool
````

### Parameter(s)
|Parameter      |Type   |Description                    |
|:---           |:---   |:---                           |
|file           |[URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) |URL of the file to check      |

### Return
The value is `true` when the given file is deletable.

## `isAccessible` class methods
Return a boolean value that indicates whether the file can be accessed or not.
````
FileManager.isAccessible(file: String, accessType: AccessType)
````

### Parameter(s)
|Parameter      |Type   |Description                    |
|:---           |:---   |:---                           |
|file           |String | The string of the file path   |
|accessType     |[AccessType](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/AcccessType.md) | Type of access to be checked. |

### Return
The value is `true` when the given file is accessible.

## `open` class method
Allocate file object by the file name and access method.
````
var file = FileManager.open(<file-name>, <access-type>) ;
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|file-name    |String or [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) |The path or URL of the file to access.|
|access-type  |String |"r" for read, "w" to write new file . and "w+" to write to append.|

### Return value
If the opening the file is succeeded, the *File* object is returned. The file-object is built-in object. It can be accessed by following methods. On the other hand, when the opening file is failed, the return value will be nil.

## `homeDirectory` method
Get the URL of home directory of current user.
````
let url = FileManager.homeDirectory() ;
````
### Parameter(s)
none

### Return value
The [URL object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) which presents the current user's home directory.

## `temporaryDirectory` method
Get the URL of temporary directory of current user.
````
let url = FileManager.temporaryDirectory() ;
````
### Parameter(s)
none

### Return value
The [URL object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) which presents the current user's home directory.

## `checkFileType` method
Check the file type given by path string.
````
const type = FileManager.checkFileType(path) ;
````

### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|path         |String |Path of the file to be checked |

### Return value
The constant value which is defined in the `type` property of the [File class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md).

|Name       |Description            |
|:---       |:---                   |
|NotExist   |Not exist              |
|File       |File                   |
|Directory  |Directory              |

The following example checks the file "tmp" is file or not:
````
  if(File.checkFileType("tmp") == File.type.File){
    /* The file named "tmp" is a file */
    ...
  }
````

## `uti` method
Get UTI of the file given by path string.
````
const uti = File.uti(path)
````

### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|path         |String |Path of the file to be checked |

### Return value
If the file pointed by "path" is exist,
the UTI of the file is returned as string.
It it is not, the return value will be *null*.

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
