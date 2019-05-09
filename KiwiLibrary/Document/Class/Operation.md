# Operation Class

## Introduction
The `Operation object` is used to execute JavaScript code on the
[operation queue](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md).
The task on the queue is executed as a thread.

The `Operation object` has user defined script to execute. The operation is implemented as the sub class of the `Operation class`

There are following steps to execute operation:

1. Allocate operation object by `Operation` function
2. Compile the user defined script by `compile` method of operation instance.
3. Use `set` method to set input values.
4. Execute the operation by the operation queue. About operation queue, see [OperationQueue class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md).
5. You can check the state of the operation by `isExecuting`, `isFinished` and `isCancelled` methods.
6. Use `get` method to get execution results.

## Class method
### `Operation`
Allocate new `Operation` instance. The instance must be *compiled* before entering into the queue.
````
let operation = Operation(console) ;
````

#### Parameters
|Name   |Type                  |Description                     |
|:---   |:---                  |:---                            |
|console |[Console](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Console.md) | The console to output from the operation. If you pass `null` as this parameter, the current console is used. |

## Methods
### `set`
Set value to operation context.
````
set(command: Int, value: Object) -> Void
````

#### Parameters
|Parameter  |Type     |Description          |
|:---       |:---     |:---                 |
|command    |Int      |Command to select object |
|value      |Object   |The `value` _must be_ the data structure which can be presented by the JSON.|

### `get`
Get value from operation context.
````
get(command: Int) -> Object
````

#### Parameters
|Parameter  |Type     |Description          |
|:---       |:---     |:---                 |
|command    |Int      |Command to select object |

### `compile`
Compile the source files and generate result into the context.
````
operation.compile(program: String) -> Bool
````

#### Parameters
|Parameter  |Type     |Description          |
|:---       |:---     |:---                 |
|program    |Array<String>   |The array of scripts be compiled. |

#### Return value
Boolean type value.
When the compilation is finished without errors,
this value will be true.

### `isExecuting`
This method returns true when the operation is running.
The return value is false when the operation is NOT started or finished or cancelled.
````
process.isExecuting
````

### `isFinished`
This method returns true when the operation is finished.
The return value is false when the operation is NOT started or executing.
````
process.isFinished
````

### `isCancelled`
This method returns true when the execution of the operation is cancelled. The return value is false when the operation is NOT started or executing or finished without cancelling.
````
process.isFinished
````

## User script

## References
* [OperationQueue Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md)
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
