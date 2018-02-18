# Process Operation
The singleton object to control the application process.

## Global variables
Following global variables are defined when this class is imported.

|Variable   |Class   | Description                     |
|:---       |:---    |:---                             |
|Process    |Process | Singleton object of Process class  |

## Process Class

### `exit` class method
Terminate process by the given exit code.
````
  Process.exit(<exit-code>)
````
#### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|exit-code    |Int    |The path of the file to access.|

#### Return value
None

### `sleep` class method
Sleep the process for a specified number of seconds.
````
  Process.sleep(<seconds>)
````

#### Parameters
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|seconds      |Double |Time to sleep. The unit of the time is *seconds*. |

#### Return value
None

## Related link
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/tree/master/KiwiLibrary): Top level document
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
