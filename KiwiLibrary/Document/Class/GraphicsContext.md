# Graphics context
The object to draw 2D graphics.
This object is allocated by [2D Graphics component](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Components/Graphics2D.md)
and used in the user's script.

# Constants

|Property name  |Type   |Description                    |
|:---           |:---   |:---                           |
|black          |Color  |The black color object         |
|red            |Color  |The red color object           |
|green          |Color  |The green color object         |
|yellow         |Color  |The yellow color object        |
|blue           |Color  |The blue color object          |
|magenta        |Color  |The magenta color object       |
|cyan           |Color  |The cyan color object          |
|white          |Color  |The white color object         |

example:
````
context.setFillColor(context.blue) ;
````

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
|color          |Color  |The color for fill operation   |

### Return value
none

## `setStrokeColor`
````
context.setStrokeColor(color) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|color          |Color  |The color to draw the line     |

### Return value
none

## `setLinewidth`
````
context.setLineWidth(width) ;
````
### Parameters
|Parameter name |Type   |Description                    |
|:---           |:---   |:---                           |
|width          |Float  |The width of the pen to draw the line|

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
|x              |Float  |The X position                 |
|y              |Float  |The Y position                 |

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
|x              |Float  |The X position                 |
|y              |Float  |The Y position                 |

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
|x              |Float  |The X position                 |
|y              |Float  |The Y position                 |
|radius         |Float  |The radius of the circle       |

### Return value
none

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
