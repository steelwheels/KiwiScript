# File class
The object to access file contents.
This object will be allocated by [FileManager](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/FileManager.md) object.

## `getc` method
Read a character from file. When there are no characters to be read, the *nil* will be returned.
````
let c = file.getc()
````
### Parameter(s)
none
### Return value
The string which contains a character. If there are no characters to be read, the *nil* will be returned.

## `getl` method
Read a line string from file. When there are no lines to be read, the *nil* will be returned.
````
let l = file.getl() ;
````
### Parameter(s)
none
### Return value
The string which contains a line string. The string is always terminalted by newline code. If there are no lines to be read, the *nil* will be returned.

## `put` method
Write the string into the file.
```
let size = file.put(string)
```
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|string       |String |The string to write into the file |
### Return value
If the write operation is succeeded, the size　(unit: byte) of parameter string is returned. If it is failed, this value will be 0.

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
