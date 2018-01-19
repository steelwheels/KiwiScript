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
|Color      |Color    |Singleton object of for the table of the colors              |

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
console.setScreenMode(<boolean value>)
````
|Value     |Description                    |
|:---      |:---                           |
|true      |Select screen modes            |
|false     |Select shell mode (default)    |

### `visiblePrompt` property
The property to show/hide the prompt.
This works for only screen mode.
````
console.visiblePrompt = <boolean-value>
````
|Value     |Description                           |  
|:---      |:---                                  |
|true      |Show prompt at the cursor position    |
|false     |Hide prompt at the cursor position (default)   |

### `doBuffering` property
The property to decide input buffering or not.
This works for only screen mode.
````
console.doBuffering = <boolean-value>
````
|Value     |Description                           |  
|:---      |:---                                  |
|true      |Accept input after the return key is pressed   |
|false     |Accept input for each keystroke (default)   |

### `doEcho` property
The property to decide to echo the input or not.
This works for only screen mode.
````
console.doEcho = <boolean-value>
````
|Value     |Description                         |  
|:---      |:---                                |
|true      |Echo the input                      |
|false     |Do not echo the input (default)     |

### `screenWidth` property
The *readonly* property to get screen width.
This works for only screen mode.
````
let width = console.screenWidth
````

### `screenHeight` property
The *readonly* property to get screen height.
This works for only screen mode.
````
let width = console.screenHeight
````

### `cursorX` property
The *readonly* property to get cursor X position.
This works for only screen mode.
````
let x = console.cursorX
````

### `cursorY` property
The *readonly* property to get cursor Y position.
This works for only screen mode.
````
let y = console.cursorY
````

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

## Color Class
The Color class has the table of colors for console.
### Color properties
Following properties are used to specify the color. Every properties has unique integer values:
* `Color.Black`
* `Color.Red`
* `Color.Green`
* `Color.Yellow`
* `Color.Blue`
* `Color.Magenta`
* `Color.Cyan`
* `Color.White`

### Utility properties
Following properties are used to traverse all colors:
* `Color.Min` : The color which has minimum properties
* `Color.Max` : The color which has maximum properties

You can traverse all colors by following statement:
````
for(let col=Color.Min ; col<=Color.Max ; col++){
  ...
}
````

### Utility methods
#### `description` method
The method to get the name of the color:
````
colorname = Color.description(Color.Red) /* -> "Red" */
````
##### Parameter(s)
|Parameter    |Type    |Description                    |
|:---         |:---    |:---                           |
|color        |Integer |The value of the color         |

##### Return value
The string to present the name. If the parameter is invalid for color, this value will be *nil*.

## Related link
* [KiwiLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/README.md): This framework contains this class.
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
