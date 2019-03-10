# Operation Class

## Introduction
The `Operation` object is used to execute JavaScript code on the
[operation queue](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md).
The code which is entered into the queue is executed as a thread.

There are following steps to execute operation:

1. Allocate operation object by `Operation` function
2. Compile the source code by `compile` method of operation instance.
3. Execute the operation by the operation queue. About operation queue, see [OperationQueue class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md).
4. Get result value from `result` property. The value is valid after execution.

## Class method
### `Operation`
Allocate new `Operation` instance. The instance must be *compiled* before entering into the queue.
````
let operation = Operation() ;
````
## Properties
### `input`
Set input parameter for the operation.

### `output`
The output parameter. This value is set by the `main_function` passed by the `compile` method.

## Methods
### `compile`
Compile the source code and generate result into the context.
````
let result = operation.compile(program, main_function) ;
````

#### Parameters
|Parameter  |Type     |Description          |
|:---       |:---     |:---                 |
|program    |String   |The entire program to execute on the queue. |
|main       |String   |The main function. The execution of the program is started by this function call.|

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
