# Thread Class

## Introduction
The `Thread` class is used to execute JavaScript on the thread.
It is used to execute JavaScript on the thread.

## Constructor Method
This method allocates the instance of `Thread` class.
````
const thread = Thread(name, input, output, error) ;
````

### Parameters
|Name   |Type           |Description                     |
|:---   |:---           |:---                            |
|name   |String         |The name of the script section in the [manifest file](https://github.com/steelwheels/JSTools/blob/master/Document/manifest-file.md). |
|input  |File           |Input stream to be read by the thread. |
|output |File           |Output stream from the thread |
|error |File           |Error stream from the thread |

### Return value
The `Thread` object to control the thread execution.
When the allocation is failed, this value will be `null`.

## Methods
### `start`
Start the thread with parameters. The parameters will be arguments of `main` function. If the thread is started without any errors, the return value will be true.
````
thread.start(arg0, arg1, args) -> Bool
````

### `waitUntilExit`
Wait until the process is finished.
The return value is exit code of the process.
````
thread.waitUntilExit() -> Int
````

## References
* [Thread function](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Thread.md): The function to generate the thread. 
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
