# Thread Class

## Introduction
The `Thread` class is used to execute JavaScript on the thread.
It is used to execute JavaScript on the thread.
The [thread function](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Thread.md) allocates this object.

## `start` method
Start the thread with parameters. The parameters will be arguments of `main` function. If the thread is started without any errors, the return value will be true.
````
thread.start(args : Array<Value>)
````

### Parameter(s)
|Name           |Type           |Description                    |
|:---           |:----          |:----                          |
|args           |Array\<Value\> |Array of primitive values.     |

### Return value
none

## `waitUntilExit` method
Wait until the process is finished.
The return value is exit code of the process.
````
thread.waitUntilExit() -> Int
````

### Parameter(s)
none

### Return value
The exit code of the thread.

## References
* [Thread function](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Thread.md): The function to generate the thread.
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
