# Operation Class

## Introduction
The `Operation` object is used to execute JavaScript code on the
[operation queue](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md) as the thread.
The code which is entered into the queue is executed as a thread.

Each instances of `Operation` has user defined script to execute the target operation. It must be implemented as a class which inherit the `Operation` built-in JavaScript class.

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
let operation = Operation() ;
````

## Methods
### `set`
Set value to operation context.
````
set(command: Int, value: Object) -> Void
````

### `get`
Get value from operation context.
````
get(command: Int) -> Object
````

### `compile`
Compile the source code and generate result into the context.
````
let result = operation.compile(program) ;
````

#### Parameters
|Parameter  |Type     |Description          |
|:---       |:---     |:---                 |
|program    |String   |The entire program to execute on the queue. |

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

## References
* [OperationQueue Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md)
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
