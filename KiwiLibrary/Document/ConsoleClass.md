# Console Operation
The *Console* class is used to operate terminal I/O.
It supports following modes:
* Shell mode (default): The shell interface based on the standard input, output and error stream
* Screen mode: Text user interface. The text user interface is is supported.

The  [ncurses](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/ncurses.3x.html) library is used to implement this.

## Global variables
Following global variables are defined for console operation.

|Variable   |Class    | Description                     |
|:---       |:---     |:---                             |
|console    |Console  | Singleton object of Console class  |

## Console Class

### `log` method
Print log message into terminal. This method can be used by all modes.
````
console.log(<message>)
````
#### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|message      |String |Log message string             |

#### Return value
none

### `setScreenMode` method
Select the console mode: *Shell mode* or *Screen mode*.
````
console.setCursesMode(<boolean value>)
````
|Value     |Description                    |
|:---      |:---                           |
|true      |Select screen modes            |
|false     |Select shell mode (default)    |

## Related link
* [KiwiLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/README.md): This framework contains this class.
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
