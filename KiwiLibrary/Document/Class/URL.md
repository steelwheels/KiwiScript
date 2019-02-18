# URL class

## Introduction
The instance of *URL* class presents the URL.

## Constructor function
The following constructor function returns URL object:
````
URL(filepath)
````

### Parameter(s)
|variable | type | description|
|:--- |:--- |:--- |
|`filepath` | String | The path string of the file |

If the `filepath` parameter is string and it's content presents
the correct URL, the allocated object has *valid* value.
Otherwise, the object has *invalid* value.

### Return value
URL object. The object is always returned even if it's contains
invalid value.

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
* [Steel Wheels Project](http://steelwheels.github.io)
