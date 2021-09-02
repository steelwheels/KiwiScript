# Readline class

## Global variables
Following global variables are defined.

|Variable   |Class      | Description                     |
|:---       |:---       |:---                             |
|Readline   |Readline   |Singleton object of Readline class   |

## `input` method
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

## `menu` method
````
menu(items: string[]): number
````
Output the menu items and wait user input.

### Parameters
Array of labels of menu item.

### Return value
n >=  0 : Index of the selected element
n == -1 : User did not select any item  

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

