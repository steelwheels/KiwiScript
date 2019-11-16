# EscapeCode class

## Global variable
The singleton object is defined for EscapeCode class.

|Variable   |Class      | Description                           |
|:---       |:---       |:---                                   |
|escapeCode |EscapeCode |Singleton object of EscapeCode class   |

## color method
Generate escape sequence to set the foreground or background color.
````
color(type: Int, color: Color) -> String
````
### Parameters
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|target       |Int    |Select target. "0":Background, "1":Foreground |
|color        |[Color](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Color.md) |The color to set as foreground or background color|

### Sample
````
let bgstr = escapeCode.color(0, Color.black) ; // for background color
let fgstr = escapeCode.color(1, Color.red ) ;  // for foreground color
console.print(fgstr + bgstr + "red message on black\n") ;
````

### Return value
Escape sequence string to set the color.
If the parameter is not acceptable, the return value will be `null`.

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
