# File Operation
The *File* class is used to generate *FileObject* object.
The file object is used to access files on local storage.

## Global variables
Following global variables are defined when this class is imported.

|Variable   |Class  | Description                     |
|:---       |:---   |:---                             |
|File       |File   | Singleton object of File class  |
|stdin      |FileObject   | Standard input            |
|stdout     |FileObject   | Standard output           |
|stderr     |FileObject   | Standard error output     |

## File class
Allocate file object by the file name and access method.
### `open` class method
````
var file = File.open(<file-name>, <access-type>)
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|file-name    |String |The path of the file to access.|
|access-type  |String |"r" for read, "w" to write new file . and "w+" to write to append.|

### Return value
If the opening the file is succeeded, the *FileObject* object is returned. The file-object is built-in object. It can be accessed by following methods. On the other hand, when the opening file is failed, the return value will be nil.

## FileObject class
### `close` method
Close the file. After the file was closed, it can not access the file.
````
var errcode = file.close()
````
#### Parameter(s)
none
#### Return value
When the closing file is succeeded, return value will be "0". If some errors were occurred, Non zero value will be returned.

### `getl` method
Read a line string from file and return it as string value. The string will be terminated by "\n" except the last line. When there are no string to be read, the return value will be *nil*.
````
var string = file.getl()
````
#### Parameter(s)
none
#### Return value
See method description.

### `getc` method
Read a character from file. When there are no characters to be read, the *nil* will be returned.
````
var c = file.getc()
````
#### Parameter(s)
none
#### Return value
The string which contains a character. If there are no characters to be read, the *nil* will be returned.

### `put` method
Write the string into the file.
```
var size = file.put(string)
```
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|string       |String |The string to write into the file |
### Return value
If the write operation is succeeded, the size　(unit: byte) of parameter string is returned. If it is failed, this value will be 0.

## Related link
* [KiwiLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/README.md): This framework contains this class.
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
