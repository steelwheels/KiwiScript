# Curses class
This document describes about `Curses` class.
This class is used to implement CUI (character user interface) on
the terminal which supports the escape sequence.

## Global variables
The singleton object is defined for Curses class.

|Variable    |Class             | Description                   |
|:---        |:---              |:---                           |
|`Curses`    |Curses            |Singleton object of the class  |

## Setup/Release
### `init` method
Initialize the screen for CUI
````
Curses.init() ;
````

### `end` method
Restore the context of terminal before calling `init` method.
````
Curses.end() ;
````

## Layout
### `width` Property
The X position of the current cursor.
````
let x = Curses.x ;
````

### `height` Property
The Y position of the current cursor.
````
let y = Curses.y ;
````

### `moveTo` method
Move the cursor (the point to put characters) to the given location.
````
Curses.moveTo(x, y) ;
````

#### Parameter(s)
|Parameter    |Type     |Description                      |
|:---         |:---     |:---                             |
|x            |Int      |The X position                   |
|y            |Int      |The Y position                   |

## Related Links
* [ncurses](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/ncurses.3x.html): Curses library
