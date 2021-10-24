# URL class

## Introduction
The object of *URL* class presents the URL.

## Constructor function
The following constructor function returns URL object:
````
declare function URL(path: string): URLIF | null ;
````
If the allocation of URL is failed, the return value will be `null`.

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
### `isNull` property
When the object has `/dev/null`, this value will be true.
````
if(url.isNull{
  has_valid_url = false ;
} else {
  has_valid_url = true ;
}
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

## Methods
### `appendingPathComponent`
Add path component (relative path) to URL object.
````
  let newurl = url.appendingPathComponent("Document/Script")
````
#### Parameter(s)
|variable | type | description                          |
|:---   |:---    |:---                                  |
|`path` | String or [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) |The path string of the file           |

#### Return value
The new [URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) object when the allocation is succeeded. If the allocation is failed, the return value will be `null`.

### `loadText` method
Load contents of the text file which pointed by the URL.
````
  let text = url.loadText() ;
````

#### Return value
The `string` is returned when the loading is succeeded. If it was failed, the value will be `null`.

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* [Steel Wheels Project](http://steelwheels.github.io)
