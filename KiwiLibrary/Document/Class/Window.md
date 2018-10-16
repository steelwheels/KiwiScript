# Window class
The CLI window allocated by [Curses object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md).

## `close` method
Close the window.
````
window.close() ;
````

## `put` method
Append string to the cursor position in the window.
````
window.put(str) ;
````

### Parameters
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|str          |String |Text to put to the window      |

## `moveTo` method
Move cursor to given position.
This works for only screen mode.
````
curses.moveTo(x, y)
````
### Parameter(s)
|Parameter    |Type    |Description                    |
|:---         |:---    |:---                           |
|x            |Int     |X position of the cursor       |
|y            |Int     |Y position of the cursor       |

### Return value
none

# Related links
* [KiwiLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The Kiwi Standard library.
