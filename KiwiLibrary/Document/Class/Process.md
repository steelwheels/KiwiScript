# Process class
## Introduction
The `Process` object presents the status of sub-process.
In usually, the object will be allocated by process creation function.

## Methods
### `isRunning`
This method returns true when the process is still running and returns false when the process is already finished.
````
process.isRunning() ;
````

### `waitUntilExit`
Wait until the process is finished.
````
process.waitUntilExit()
````

## Related link
* [Amber Frameworks](https://github.com/steelwheels/Amber/blob/master/README.md): This framework contains this class.
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
