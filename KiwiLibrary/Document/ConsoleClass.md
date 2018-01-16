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
|console    |Console  |Singleton object of Console class  |
|Color      |Color    |Table of the colors              |

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

### `visiblePrompt` property
The property to show/hide the prompt.
````
console.visiblePrompt = <boolean-value>
````
|Value     |Description                           |  
|:---      |:---                                  |
|true      |Show prompt at the cursor position    |
|false     |Hide prompt at the cursor position (default)   |

### `doBuffering` property
The property to decide input buffering or not.
````
console.doBuffering = <boolean-value>
````
|Value     |Description                           |  
|:---      |:---                                  |
|true      |Accept input after the return key is pressed   |
|false     |Accept input for each keystroke (default)   |

### `doEcho` property
The property to decide to echo the input or not.
````
console.doEcho = <boolean-value>
````
|Value     |Description                         |  
|:---      |:---                                |
|true      |Echo the input                      |
|false     |Do not echo the input (default)     |

### `getKey` method
Get last pressed key.
You can use this method when the current mode is screen mode.

#### Parameter(s)
No parameters.

#### Return values
When any key are pressed, the key code will be returned.
If no keys are pressed, this method return *null*.

## Color Class
The Color class has the table of colors for console.
### Color properties
Following properties are used to specify the color:
* `Color.Black`
* `Color.Red`
* `Color.Green`
* `Color.Yellow`
* `Color.Blue`
* `Color.Magenta`
* `Color.Cyan`
* `Color.White`

## Related link
* [KiwiLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/README.md): This framework contains this class.
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
