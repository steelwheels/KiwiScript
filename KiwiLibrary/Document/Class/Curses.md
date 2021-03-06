# Curses class
This document describes about `Curses` class.
This class is used to implement CUI (character user interface) on
the terminal which supports the escape sequence.

## Global variables
The singleton object is defined for Curses class.

|Variable    |Class             | Description                   |
|:---        |:---              |:---                           |
|`Curses`    |Curses            |Singleton object of the class  |

## Properties
### Color code
Following properties has unique integer value to present colors.

`black`, `red`, `green`, `yellow`, `blue`, `maganta`, `cyan`, `white`

### Minimum/Maximum value of Color code
`minColor`, `maxColor`


## Setup/Release
### `start` method
Startup the screen for CUI
````
Curses.start() ;
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

### `inkey` method
Get current input character. If no key is pressed, the return value will be `null`. This method *IS NOT* blocked when the no key is pressed.
(The `getc` method in [File class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) is blocked until some input is given.)
````
let c = Curses.inkey() ;
````

## Color
### `foregroundColor` Property
The foreground color of the terminal.
````
let fcol = Curses.foregroundColor ;
Curses.foregroundColor = Curses.black ;
````

### `backgroundColor` Property
The background color of the terminal.
````
let bcol = Curses.backgroundColor ;
Curses.backgroundColor = Curses.white ;
````

## Related Links
* [ncurses](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/ncurses.3x.html): Curses library
