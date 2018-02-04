# Console Operation
The *Console* class is used to operate terminal I/O.
It supports following modes:
* *Shell mode* (default): The shell interface based on the standard input, output and error stream
* *Screen mode*: Text user interface. The text user interface is is supported.

The  [ncurses](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/ncurses.3x.html) library is used to implement this.

## Global variables
Following global variables are defined for console operation.

|Variable   |Class    | Description                     |
|:---       |:---     |:---                             |
|console    |Console  |Singleton object of Console class  |
|Color      |Color    |Table of the colors              |
|Align      |Align    |Table of alignment kinds |

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

|Value  |Access | Description              |  
|:---   |:---   |:---                      |
|Bool   |Read/Write| *true*: Select screen mode |
|       |          | *false*: Select shell mode (default) |

### `visiblePrompt` property
The property to show/hide the prompt.

|Value  |Access | Description              |  
|:---   |:---   |:---                      |
|Bool   |Read/Write| *true*: Show prompt     |
|       |          | *false*: Hide prompt    |

### `doBuffering` property
The property to decide input buffering or not.

|Value     |Access | Description                        |  
|:---      |:---   |:---                                |
|Bool    |Read/Write| *true*: Accept input after the return key is pressed  |
|        |          | *false*: Accept input for each keystroke (default)  |

### `doEcho` property
The property to decide echo the input or not.

|Value     |Access | Description                        |  
|:---      |:---   |:---                                |
|Bool    |Read/Write| *true*: Echo the input |
|        |          | *false*: Do not echo the input |

### `screenWidth` property
This works under screen mode.

|Value      |Access | Description             |
|:---       |:---   | :---                    |
|Int |Read Only |Screen width|

### `screenHeight` property
This works under screen mode.

|Value      |Access | Description             |
|:---       |:---   | :---                    |
|Int |Read Only |Screen height|

### `cursorX` property
|Value      |Access | Description             |
|:---       |:---   | :---                    |
|Int |Read Only |Current cursor X position|

### `cursorY` property
|Value      |Access | Description             |
|:---       |:---   | :---                    |
|Int |Read Only |Current cursor Y position|

### `setColor` method
Set foreground and background color. About the color parameter, see *Color class* in this document.
````
setColor(forecol, backcol) ;
````

|Parameter    |Type    |Description                   |
|:---         |:---    |:---                          |
|forecol      |Int     |Foreground color              |
|backcol      |Int     |Background color              |

### `moveTo` method
Move cursor to given position.
This works for only screen mode.
````
moveTo(x, y)
````
#### Parameter(s)
|Parameter    |Type    |Description                    |
|:---         |:---    |:---                           |
|x            |Int     |X position of the cursor       |
|y            |Int     |Y position of the cursor       |

#### Return value
none

### `getKey` method
Get last pressed key.
This works for only screen mode.

#### Parameter(s)
No parameters.

#### Return values
When any key are pressed, the key code will be returned.
If no keys are pressed, this method return *null*.

## Related link
* [KiwiLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/README.md): This framework contains this class.
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
