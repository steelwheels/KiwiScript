# EscapeCode class

## Global variable
The singleton object is defined for EscapeCode class.

|Variable   |Class      | Description                           |
|:---       |:---       |:---                                   |
|EscapeCode |EscapeCode |Singleton object of EscapeCode class   |

## `cursorNextLine` method
Move cursor to head of next line.
The number of lines to move is given as a parameter.
````
let code = EscapeCode.cursorNextLine(1) ;
````

## `cursorPreviousLine` method
Move cursor to head of previous line.
The number of lines to move is given as a parameter.
````
let code = EscapeCode.escapeCode.cursorPreviousLine(1) ;
````

## `saveCursorPosition` method
Save current cursor position.
````
let code = EscapeCode.saveCursorPosition()
````

## `restoreCursorPosition` method
Restore cursor position which is stored by `saveCursorPosition` method.
````
let code = EscapeCode.restoreCursorPosition()
````

## `eraceFromCursorToEnd` method
Erace all text from cursor to the end of string.
````
let code = EscapeCode.eraceFromCursorToEnd()
````

## `eraceFromCursorToBegin` method
Erace all text from beginning to the cursor.
````
let code = EscapeCode.eraceFromCursorToBegin()
````

## `eraceEntireBuffer` method
Erace all text.
````
let code = EscapeCode.eraceEntiferBuffer()
````

## `eraceFromCursorToRight` method
Erace string from cursor to the end of the line.
````
let code = EscapeCode.eraceFromCursorToRight()
````

## `eraceFromCursorToLeft` method
Erace string from beginning of the line to the cursor
````
let code = EscapeCode.eraceFromCursorToLeft()
````

## `scrollUp` method
Generate escape sequence to scroll up the terminal.
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
let code = EscapeCode.color(type: Int, color: Color) -> String
````
### Parameters
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|target       |Int    |Select target. "0":Background, "1":Foreground |
|color        |[Color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Color.md) |The color to set as foreground or background color|

### Return value
Escape sequence string to set the color.
If the parameter is not acceptable, the return value will be `null`.

### Sample
````
let bgstr = EscapeCode.color(0, Color.black) ; // for background color
let fgstr = EscapeCode.color(1, Color.red ) ;  // for foreground color
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
