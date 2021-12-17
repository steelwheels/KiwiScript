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
context.setPenSize(width: number) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|width          |number |The logical width/height of the pen to draw the line|

### Return value
none

## `moveTo`
Move the pen to given point.
````
context.moveTo(x:number, y:number) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|x              |number  |The logical X position                 |
|y              |number  |The logical Y position                 |

### Return value
none

## `lineTo`
Draw the line from the current pen position to given position.
````
context.lineTo(x:number, y:number) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|x              |number  |The logical X position                 |
|y              |number  |The logical Y position                 |

### Return value
none

## `rect`
Draw the rectangle at given position and size.
````
context.rect(x:number, y:number, width:number, height:number, dofill:boolean)
````
### Parameters
|Parameter name |Type   |Description                    |
|:--            |:--    |:--                            |
|x              |number |The logical X position         |
|y              |number |The logical Y position         |
|width          |number |The width of the rectangle     |
|height         |number |The height of the rectangle    |
|dofill         |boolean | *True*: Fill the contents, *False*: Does not fill|

## `circle`
Draw the circle at given position and radius.
````
context.circule(x:number, y:number, radius:number, dofill:boolean) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|x              |number  |The logical X position                 |
|y              |number  |The logical Y position                 |
|radius         |number  |The logical radius of the circle       |
|dofill         |boolean | *True*: Fill the contents of the circle. *False*: Does not fill|

### Return value
none

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* [Turtle class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/Turtle.md): Buillt-in JavaScript class for turtle graphics.


