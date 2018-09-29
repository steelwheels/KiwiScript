# Process Class

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

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

