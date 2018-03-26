# Contact class
The *Contact* class is used to access contact database on the macOS.

## Important notice
You have to allow the terminal to access contact database.
(You can control the accessibility by the system preference panel.)

## Global variables
Following global variables are defined for console operation.

|Variable   |Class    | Description                      |
|:---       |:---     |:---                              |
|contact    |Contact  |Singleton object of Contact class |

## Console Class
### `authorize` method
Try to authorize the accessibility to the contact database.
````
const status = contact.authorize()
````

#### Parameters(s)
none

#### Return value
The authorization result. See "Authorize Type" in [Global data type](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/GlobalType.md).


## Related link
* [KiwiLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/README.md): This framework contains this class.
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
