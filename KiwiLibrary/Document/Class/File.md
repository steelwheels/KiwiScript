# File class
The object to access file contents.
This object will be allocated by [FileManager](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/FileManager.md) object.

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
