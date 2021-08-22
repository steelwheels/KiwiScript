# Readline class

## Global variables
Following global variables are defined.

|Variable   |Class      | Description                     |
|:---       |:---       |:---                             |
|Readline   |Readline   |Singleton object of Readline class   |

## `inputLine` method
````
input(): string
````
Read a line string from standard input. This method is blocked until user inputs the newline.

### Parametrer(s)
none
### Return value
The string which does *NOT* contains newline code.

## `history` method
````
history(): string[]
````
Return the list of previous commandline inputs

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

