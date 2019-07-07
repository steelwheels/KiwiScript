# Operation class

## Introduction
The `Operation` class is used to execute JavaScript code on a thread.
There is rule to describe JavaScript code on the queue.

## The constructor method
This method allocates the instance of `Operation` class.
````
const operation = Operation(URLs, console) ;
````

### Parameters
|Name   |Type                  |Description                     |
|:---   |:---                  |:---                            |
|URLs    |Array<[URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md)> | Array of the URLs for user scripts. |
|console |[Console](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Console.md) | The console to output from the operation. If you pass `null` as this parameter, the caller's console is used. |

You can give some URLs which has the user scripts.
The script must be described by the following rules:

1. The class which inherits the `Operation` class is defined.
2. The class has `main` method in it. The method will be executed as a thread in the operation queue.
3. Define the `operation` instance of the class.

If you don't define the `operation` instance, the compilation will be failed.

## Methods
### `isFinished` method
````
  let flag = operation.isFinished() ;
````

#### Return value
Boolean value. This value become *true* after the operation is finished with or without `cancel`.
This value is kept until the operation is executed again.

### `isCancelled` method
````
  let flag = operation.isCancelled() ;
````

#### Return value
Boolean value. This value become *true* after the operation was terminated by `cancel` command.
This value is kept until the operation is executed again.

### `setConsole` method
Change the output target. After this method call, the output of `console` object will be switched to the new one.
````
  operation.setConsole(console) ;
````

#### Parameters
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|console      |[Console](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Console.md) |New output target             |

#### Return value
none

### `executionCount` method
````
  let count = operation.executionCount() :
````

#### Return value
Integer value. This value presents the execution count of the operation.

### `totalExecutionTime` method
````
  let count = operation.totalExecutionTime() :
````

#### Return value
Double value. The unit is `msec`.
This value is the total execution time of the operation.

## References
* [OperationQueue](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md): The queue to execute the operation.
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
