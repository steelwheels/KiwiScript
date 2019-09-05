# File Class
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

## `open` class method
Allocate file object by the file name and access method.
````
var file = File.open(<file-name>, <access-type>) ;
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|file-name    |String or [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) |The path or URL of the file to access.|
|access-type  |String |"r" for read, "w" to write new file . and "w+" to write to append.|

### Return value
If the opening the file is succeeded, the *File* object is returned. The file-object is built-in object. It can be accessed by following methods. On the other hand, when the opening file is failed, the return value will be nil.

## `type` property
Type property has following constant values to present type of the file.

|Name       |Description            |
|:---       |:---                   |
|NotExist   |Not exist              |
|File       |File                   |
|Directory  |Directory              |

## `checkFileType` method
Check the file type given by path string.
````
const type = File.checkFileType(path) ;
````

### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|path         |String |Path of the file to be checked |

### Return value
The constant value which is defined in the `type` property of this class.
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

# File class
## `close` method
Close the file. After the file was closed, it can not access the file.
````
var errcode = file.close()
````
### Parameter(s)
none
### Return value
When the closing file is succeeded, return value will be "0". If some errors were occurred, Non zero value will be returned.

## `getl` method
Read a line string from file and return it as string value. The string will be terminated by "\n" except the last line. When there are no string to be read, the return value will be *nil*.
````
var string = file.getl()
````
### Parameter(s)
none
### Return value
See method description.

## `getc` method
Read a character from file. When there are no characters to be read, the *nil* will be returned.
````
var c = file.getc()
````
### Parameter(s)
none
### Return value
The string which contains a character. If there are no characters to be read, the *nil* will be returned.

## `put` method
Write the string into the file.
```
var size = file.put(string)
```
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|string       |String |The string to write into the file |
## Return value
If the write operation is succeeded, the size　(unit: byte) of parameter string is returned. If it is failed, this value will be 0.

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
