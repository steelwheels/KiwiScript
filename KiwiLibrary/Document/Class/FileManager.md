# File Manager Class
The *FileManager* class is used to allocate *File* class.
The File is used to read and/or write the file.

## Global variables
Following global variables are defined.

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

## `openPanel` method
Display the dialog to select a file by the user.
````
let url = FileManager.openPanel("Title", FileType.File, ["js"]) ;
if(url != null) {
  // The url variable has the URL of selected file
} else {
  // User did not select any files
}
````

### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|title        |String |Title of the dialog            |
|file-type    |[FileType](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/FileType.md) |The type of the file to be selected. |
|extensions   |Array<String> |The array of strings. Each string is an file extension to be opened. |

### Return value
If the user select a file (or directory) and close the dialog,
The return value is [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/FileType.md) of selected file (or directory). If the user does not select anything, this value will be `null`.

## `homeDirectory` method
Get the URL of home directory of current user.
````
let url = FileManager.homeDirectory() ;
````
### Parameter(s)
none

### Return value
The [URL object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) which presents the current user's home directory.

## `currentDirectory` method
Get the URL of current directory
````
let url = FileManager.currentDirectory() ;
````

### Parameter(s)
none

### Return value
The [URL object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) which presents the current user's current directory.

## `setCurrentDirectory` method
Set the URL of current directory
````
FileManager.setCurrentDirectory(url) ;
````

### Parameter(s)
The [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) or string for the new current directory.
You can path the relative path string against the current directory.

### Return value
If the changing current directory succeeded, this value will be true.
Otherwise this value will be false.

## `temporaryDirectory` method
Get the URL of temporary directory of current user.
````
let url = FileManager.temporaryDirectory() ;
````
### Parameter(s)
none

### Return value
The [URL object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) which presents the current user's home directory.

## `resourceDirectory` method
Get the URL of resource directory foreach application and framework.
````
let url = FileManager.resourceDirectory("name") ;
````
### Parameter(s)
|Name   |Type     |Description                          |
|:--    |:--      |:--                                  |
|name   |String   |Name of application or library       |

Following resource names are supported:

|Name           |Resource owner                               |
|:--            |:--                                          |
|`Library`      |[KiwiLibrary framework](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/README.md) |
|`Shell`        |[KiwiShell framework](https://github.com/steelwheels/KiwiScript/blob/master/KiwiShell/README.md) |

### Return value
The [URL object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) which presents the resource directory.

## `fullPath` method
Convert relative-path declaration into full-path declaration.
````
let fullpath = FileManager.fullpath(path: String, currentDir: URL)
````

### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|path         |String |Path of the file               |
|curdir       |[URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) |URL of current directory |

If the given `path` is *absolute path*, the URL of it is returned.
If the given `path` is *relative path*, the `curdir` URL is treated as the parent path of the `path`. The result of merging is returned as full path URL.

You can get URL of current directory by `currentDirectory` method of the [Environment](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Environment.md) class.

### Return value
The URL of full path to point the given `path`.
If the parameters are invalid, the return value will be `null`.

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
