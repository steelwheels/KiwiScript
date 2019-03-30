# String Functions
## `format` function
````
format(format: String, arg0, arg1, ... : String) -> String
aformat(format: String, args : [String]) -> String
````
### Parameters
See [String format specifiers](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html) for `format` parameter.

|Name   |Type   |Description                          |
|:--    |:--    |:--                                  |
|format |String |The string to present target format  |
|argX   |String |0 or more arguments to be printed    |

### Return value
When the string formatted without errors, the formatted string is returned. Otherwise, the return value will be `null`.

## References
* [Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
