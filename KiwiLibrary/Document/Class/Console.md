# Console class
The *Console* class is used to print text to console.

## Global variables
Following global variables are defined for console operation.

|Variable   |Class    | Description                     |
|:---       |:---     |:---                             |
|console    |Console  |Singleton object of Console class  |

### `log` method
Print log message to standard output.
````
console.log(<message>)
````
#### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|message      |String |Log message string             |

#### Return value
none

### `print` method
Print message to standard output.
````
console.print(<message>)
````
#### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|message      |String |Log message string             |

#### Return value
none

### `error` method
Print error message. This method can be used by all modes.
````
console.error(<message>)
````
#### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|message      |String |Error message string           |

#### Return value
none

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library


