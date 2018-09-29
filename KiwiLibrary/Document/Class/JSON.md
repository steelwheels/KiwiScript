# JSON class
The *JSON* class is used to parse JSON string, encode JSON data into string. This class also supports read/write JSON file.

## `read` class method
Read text from file and parse it into JSON object.
````
var file = JSON.read(<file-name>)
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|file-name    |String |The path of the file to read.|
### Return value
The JSON object is returned when the read and parse operation was succeeded, otherwise this value will be *null*.

## `write` class method
Encode JSON data into string and write it to text file.
````
var size = JSON.write(<file-name>, <object>)
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|file-name    |String |The path of the file to write.|
|object       |Object |The source object to be encoded |
### Return value
The error code is returned as an integer value.

|Error code   |Description                            |
|:---         |:---                                   |
|0            |No errors (Succeeded)                  |
|1            |Invalid file name                      |
|2            |Failed to make JSON from given string  |
|3            |Failed to write JSON file              |

## `serialize` class method
Encode JSON data into string.
````
var string = JSON.serialize(object)
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|object       |Object |The source object to be encoded |

### Return value
When the serialization is succeeded, the returned value is string which presents the JSON object by text.
If the serialization is failed, this value will be *null*.

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

