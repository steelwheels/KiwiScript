# Operation Class

## Introduction
The `Operation` object is used to execute JavaScript code on the
[operation queue](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md).
The code which is entered into the queue is executed as a thread.

## Class method
### `Operation`
Allocate new `Operation` instance. The instance must be *compiled* before entering into the queue.
````
let operation = Operation() ;
````

## Methods
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
