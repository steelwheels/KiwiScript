# Console class
The *Console* class is used to print text to console.

## Global variable
The singleton object is defined for Console class.

|Variable   |Class    | Description                     |
|:---       |:---     |:---                             |
|console    |Console  |Singleton object of Console class  |

## `print` method
Print message to standard output.
````
console.print(<message>)
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|message      |String |Log message string             |

### Return value
none

## `error` method
Print error message. This method can be used by all modes.
````
console.error(<message>)
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|message      |String |Error message string           |

### Return value
none

## `dump` method
Print the context of the variable
````
console.dump(value)
````
#### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|value        |Any    |The value to dump it's context |

### Return value
none

## References
* [Debug class](Console.md): The `Debug` class
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
