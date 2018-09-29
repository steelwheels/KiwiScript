# Curses class
The *Curses* class is used to operate terminal by The  [ncurses](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/ncurses.3x.html).

## `mode` method
Enter/leave screen mode.
````
curses.mode(<mode>) ;   /* Enter or leave screen mode */
````

### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|mode         |Bool   |`True`: Switch to screen mode, `False` switch to console mode. |

## `put` method
Print log message.
````
curses.put(<message>)
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|message      |String |Message string                 |

### Return value
none

## `error` method
Print error message. This method can be used by all modes.
````
curses.error(<message>)
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|message      |String |Error message string           |

### Return value
none

## `setScreenMode` method
Select the console mode: *Shell mode* or *Screen mode*.

|Value  |Access | Description              |  
|:---   |:---   |:---                      |
|Bool   |Read/Write| `true`: Select screen mode |
|       |          | `false`: Select shell mode (default) |

### `visiblePrompt` property
The property to show/hide the prompt.

|Value  |Access | Description              |  
|:---   |:---   |:---                      |
|Bool   |Read/Write| `true`: Show prompt (default), `false`: Hide prompt    |

### `doBuffering` property
The property to decide input buffering or not.

|Value     |Access | Description                        |  
|:---      |:---   |:---                                |
|Bool    |Read/Write| `true`: Accept input after the return key is pressed, `false`: Accept input for each keystroke (default)  |

## `doEcho` property
The property to decide echo the input or not.

|Value     |Access | Description                        |  
|:---      |:---   |:---                                |
|Bool    |Read/Write| `true`: Echo the input,  `false`: Do not echo the input |

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
curses.setColor(forecol, backcol) ;
````

|Parameter    |Type    |Description                   |
|:---         |:---    |:---                          |
|forecol      |Int     |Foreground color              |
|backcol      |Int     |Background color              |

## `moveTo` method
Move cursor to given position.
This works for only screen mode.
````
curses.moveTo(x, y)
````
### Parameter(s)
|Parameter    |Type    |Description                    |
|:---         |:---    |:---                           |
|x            |Int     |X position of the cursor       |
|y            |Int     |Y position of the cursor       |

### Return value
none

## `getKey` method
Get last pressed key.
This works for only screen mode.

### Parameter(s)
No parameters.

### Return values
When any key are pressed, the key code will be returned.
If no keys are pressed, this method return *null*.

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

