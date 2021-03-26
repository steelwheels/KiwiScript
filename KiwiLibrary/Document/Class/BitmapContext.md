# Bitmap context
The object to draw 2D graphics.
This object is allocated by [2D Bitmap component](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Components/Bitmap.md)
and used in the user's script.

# Properties
|Property name  |Type   |Description                    |
|:---           |:---   |:---                           |
|width          |Int    |Number of horizontal pixels    |
|height         |Int    |Number of vertical pixels      |

# Methods
## `set(x, y, color)`
````
context.set(x, y, color) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|x              |Int    |X position                     |
|y              |Int    |Y position                     |
|color          |[Color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Color.md)  |The color for fill operation   |

### Return value
none

## `get(x, y)`
````
let color = context.get(x, y) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|x              |Int    |X position                     |
|y              |Int    |Y position                     |

### Return value
The [color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Color.md) object.

## `clear()`
````
context.clear() ;
````
Fill all bits by clear color.

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* [Turtle class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/Turtle.md): Buillt-in JavaScript class for turtle graphics.


