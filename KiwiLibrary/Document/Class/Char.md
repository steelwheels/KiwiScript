# Char class
The `Char` class is used to define function and constants for character operation.

## Global variable
The singleton object is defined for Console class.

|Variable   |Class    | Description                     |
|:---       |:---     |:---                             |
|char       |Char     |Singleton object of `Char` class |

## Properties to get ASCII control character
````
  let c = char.ESC ;    // Get escape character code
````
|Property name  |Description            |
|:--            |:---                   |
|`Char.BS`      |Backspace              |
|`Char.TAB`     |Tab                    |
|`Char.LF`      |Line feed              |
|`Char.VT`      |Vertical Tabulation    |
|`Char.CR`      |Carriage Return        |
|`Char.ESC`     |Escape                 |
|`Char.DEL`     |Delete                 |

## References
* [Ascii Control Codes](http://jkorpela.fi/chars/c0.html)
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
