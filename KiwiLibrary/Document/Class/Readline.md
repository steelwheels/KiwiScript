# Readline class

## Global variables
Following global variables are defined.

|Variable   |Class      | Description                     |
|:---       |:---       |:---                             |
|Readline   |Readline   |Singleton object of Readline class   |

## `inputLine` method
````
inputLine(): string
````
Read a line string from standard input. This method is blocked until user inputs the newline.

### Parametrer(s)
none
### Return value
The string which does *NOT* contains newline code.

## `inputInteger` method
````
inputInteger(): number
````
Read a line string from standard input. This method is blocked until user inputs the newline.
If the string is NOT present the number, the result value will be `NaN`. The [isNaN() function](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/TypeChecks.md) can be used to check the value is NaN or not.


# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

