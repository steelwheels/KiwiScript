# URL class

## Constructor
The following constructor function returns URL object:
````
URL(filepath)
````
### Parameter(s)
|variable | type | description|
|:--- |:--- |:--- |
|`filepath` | String | The path string of the file |

### Return value
URL object for given file file path

## Properties
### `absoluteString` property
String property which presents the full path name of the URL.
If the object has invalid value, this value will be `null`.
````
var str = url.absoluteString ;
````

### `path` property
String property which presents the path string.
If the object has invalid value, this value will be `null`.
````
var str = url.path ;
````

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
