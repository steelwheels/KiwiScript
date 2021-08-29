# JSON class
The *JSON* class is used to parse JSON string, encode JSON data into string. This class also supports read/write JSON file.
This class is implemented as JavaScript class.
You have to allocate the object to use it.

````
let file = new JSONFile() ;
file.write(stdout, object) ;
````

## `read` class method
Read text from file and parse it into JSON object.
````
var object: Object = JSON.read(file: File): value | null
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|file         |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) |The file object to read JSON data|
### Return value
The JSON object is returned when the read and parse operation was succeeded, otherwise this value will be *null*.

## `write` class method
Encode JSON data into string and write it to text file.
````
var result: Bool = JSON.write(file: File, obj: Object)
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|file         |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) |The file object to write.|
|object       |Object |The source object to be encoded |
### Return value
The the file writing is finished without any errors, this value will be 'true'.

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

