# Graphics context
The object to draw 2D graphics.
This object is allocated by [2D Graphics component](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Components/Graphics2D.md)
and used in the user's script.

The [Turtle class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/Turtle.md) uses this instance to draw graphics.

# Properties
|Property name  |Type   |Description                    |
|:---           |:---   |:---                           |
|logicalFrame   |[Rect](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Primitive/Rect.md)| The rectangle to present the drawing field. |

# Methods
## `setFillColor`
````
context.setFillColor(color) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|color          |[Color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Color.md)  |The color for fill operation   |

### Return value
none

## `setStrokeColor`
````
context.setStrokeColor(color) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|color          |[Color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Color.md)  |The color to draw the line     |

### Return value
none

## `setPenSize`
````
context.setPenSize(width) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|width          |Float  |The logical width/height of the pen to draw the line|

### Return value
none

## `moveTo`
Move the pen to given point.
````
context.moveTo(x, y) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|x              |Float  |The logical X position                 |
|y              |Float  |The logical Y position                 |

### Return value
none

## `lineTo`
Draw the line from the current pen position to given position.
````
context.lineTo(x, y) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|x              |Float  |The logical X position                 |
|y              |Float  |The logical Y position                 |

### Return value
none

## `circle`
Draw the circle at given position and radius.
````
context.circule(x, y, radius) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|x              |Float  |The logical X position                 |
|y              |Float  |The logical Y position                 |
|radius         |Float  |The logical radius of the circle       |

### Return value
none

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* [Turtle class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/Turtle.md): Buillt-in JavaScript class for turtle graphics.


