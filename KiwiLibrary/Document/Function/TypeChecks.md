# Type check functions

## Type check functions
Following functions checks the type of values.
They have one parameter and return boolean value.
Here is the usage of `isUndefined` function.
````
const flag = isUndefined(value) ;
````
|Function name  |Type to check              |
|:---           |:---                       |
|isUndefined    |Undefined                  |
|isNull         |Null                       |
|isBoolean      |Boolean                    |
|isNumber       |Number (integer or float)  |
|isString       |String                     |
|isObject       |Object                     |
|isArray        |Array                      |
|isDate         |Date                       |
|isPoint        |Point                      |
|isSize         |Size                           |
|isURL          |[URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md) |
|isImage        |[Image](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Image.md) |
|isBitmap       |[Bitmap](https://github.com/steelwheels/Amber/blob/master/Document/DataFormat/Bitmap.md) |
|isEOF          |The End-Of-File character      |

## Type obtaining function
### `typeID` function
The `typeID` function returns enum value for the type of the given value. The enum is defined in [TypeID](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/TypeID.md) documentation.

````
typeID(val: AnyValue) -> Int
````
#### Parameter
`AnyValue`: Source parameter to get the type identifier.

#### Return value
The type id of source value. The list of type ids are defined in [TypeID type](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/TypeID.md).

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
