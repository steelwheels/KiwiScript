# File class
The *File* class is used to access files on local storage.

## Constructor
````
var file = File.open(<file-name>, <access-type>)
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|file-name    |String |The path of the file to access.|
|access-type  |String |"r" for read, "w" to write new file . and "w+" to write to append.|

### Return value
If the opening the file is succeeded, the File-object is returned. The file-object is built-in object. It can be accessed by following methods. On the other hand, when the opening file is failed, the return value will be nil.

## Method(s)
### `close` method
Close the file. After the file was closed, it can not access the file.
````
var errcode = file.close()
````
#### Parameter(s)
none
#### Return value
When the closing file is succeeded, return value will be "0". If some errors were occurred, Non zero value will be returned.

### `getLine` method
Read a line string from file and return it as string value. The string will be terminated by "\n" except the last line. When there are no string to be read, the return value will be *nil*.
````
var string = file.getLine()
````
#### Parameter(s)
none
#### Return value
See method description.

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
If the write operation is succeeded, the size of parameter string is returned. If it is failed, this value will be 0.
