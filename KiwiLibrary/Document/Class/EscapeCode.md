# EscapeCode class
This class is used to generate [escape sequence](https://www.xfree86.org/current/ctlseqs.html) string. 


## Global variable
The singleton object is defined for EscapeCode class.

|Variable   |Class      | Description                           |
|:---       |:---       |:---                                   |
|EscapeCode |EscapeCode |Singleton object of EscapeCode class   |

## `cursorUp`, `cursorDown`, `cursorForward`, `cursorBackward` method
Return the escape sequence to move cursor. Each method has an argument to present number of movements.
`````
let code = EscapeCode.cursorUp(1) ;
`````

## `cursorNextLine` method
Return the escape sequence to move cursor to head of next line.
The number of lines to move is given as a parameter.
````
let code = EscapeCode.cursorNextLine(1) ;
````

## `cursorPreviousLine` method
Return the escape sequence to move cursor to head of previous line.
The number of lines to move is given as a parameter.
````
let code = EscapeCode.escapeCode.cursorPreviousLine(1) ;
````

## `cursorMoveTo` method
Return the escape sequence to move cursor to cursor (x, y). These parameters are started from 1 (Not 0).
````
let code = EscapeCode.moveCursorTo(y, x) ;
````

## `saveCursorPosition` method
Return the escape sequence to save current cursor position.
````
let code = EscapeCode.saveCursorPosition()
````

## `restoreCursorPosition` method
Return the escape sequence to restore cursor position which is stored by `saveCursorPosition` method.
````
let code = EscapeCode.restoreCursorPosition()
````

## `eraceFromCursorToEnd` method
Return the escape sequence to erace all text from cursor to the end of string.
````
let code = EscapeCode.eraceFromCursorToEnd()
````

## `eraceFromCursorToBegin` method
Return the escape sequence to erace all text from beginning to the cursor.
````
let code = EscapeCode.eraceFromCursorToBegin()
````

## `eraceEntireBuffer` method
Return the escape sequence to erace all text.
````
let code = EscapeCode.eraceEntiferBuffer()
````

## `eraceFromCursorToRight` method
Return the escape sequence to erace string from cursor to the end of the line.
````
let code = EscapeCode.eraceFromCursorToRight()
````

## `eraceFromCursorToLeft` method
Return the escape sequence to erace string from beginning of the line to the cursor
````
let code = EscapeCode.eraceFromCursorToLeft()
````

## `scrollUp` method
Return the escape sequence to scroll up the terminal.
````
let code = EscapeCode.scrollUp(lines: Int) -> String
````

### Parameters
|Parameter    |Type     |Description                    |
|:---         |:---     |:---                           |
|lines        |Int      |Number of lines to scroll up   |


## `scrollDown` method
Generate escape sequence to scroll down the terminal.
````
let code = EscapeCode.scrollDown(lines: Int) -> String
````

### Parameters
|Parameter    |Type     |Description                    |
|:---         |:---     |:---                           |
|lines        |Int      |Number of lines to scroll down |


## `color` method
Generate escape sequence to set the foreground or background color.
````
let code = EscapeCode.color(type: Int, color: Int) -> String
````
The value of the color is defined as the property of [Curses class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md).

### Parameters
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|target       |Int    |Select target. "0":Background, "1":Foreground |
|color        |Int    |The color to set as foreground or background color. The value of the color is defined as the property of [Curses class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Curses.md).|

### Return value
Escape sequence string to set the color.
If the parameter is not acceptable, the return value will be `null`.

### Sample
````
let bgstr = EscapeCode.color(0, Curses.black) ; // for background color
let fgstr = EscapeCode.color(1, Curses.red ) ;  // for foreground color
console.print(fgstr + bgstr + "red message on black\n") ;
````

## `reset` method
Reset all attributes to initial default values.
````
reset() -> String
````

### Parameters
none

### Return value
Escape sequence string to reset attributes.

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
