# URL class

## Introduction
The object of *URL* class presents the URL.

## Constructor function
The following constructor function returns URL object:
````
URL(filepath)
````
If you pass empty string as `filepath` parameter,
The instance will have invalid value.

### Parameter(s)
|variable | type | description|
|:--- |:--- |:--- |
|`filepath` | String | The path string of the file |

If the `filepath` parameter is string and it's content presents
the correct URL, the allocated object has *valid* value.
Otherwise, the object has *invalid* value.
If you have empty string, the object has *invalid* value.

### Return value
URL object. The object is always returned even if it's contains
invalid value.

## Properties
### `isValid` property
When the object has valid URL, this value will be true.
````
let str = url.isValid ? url.absoluteString : "<unknown>" ;
````

### `absoluteString` property
String property which presents the full path name of the URL.
If the object has invalid value, this value will be `null`.
````
let str = url.absoluteString ;
````

### `path` property
String property which presents the path string.
If the object has invalid value, this value will be `null`.
````
let str = url.path ;
````

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* [Steel Wheels Project](http://steelwheels.github.io)
