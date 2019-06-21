# OperationQueue Class

## Introduction
The `OperationQueue` object is engine to execute the context of [operation instance](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Operation.md).

## Class Method
### `OperationQueue`
Allocate new `OperationQueue` instance.
````
let operation = OperationQueue() ;
````

## Methods
### `execute`
Execute the [operation](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Operation.md) instance on the queue.
````
let result = queue.execute(operation, time_limit, finalop) ;
````

#### Parameters
|Parameter    |Type           |Description    |
|:--          |:--            |:--            |
|operation    |[Operation](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Operation.md) |The operation to execute it's context |
|time_limit   |Double or `nil` |The time limit of the execution of the operation. If the `time_limit` is NOT nil, the execution of the operation is cancelled after `time_limit` seconds. |
|finalop      | (op: Operation) -> Void | Callback function which is called after the main operation is finished. You can pass `null` to skip this operation.|

When the operation is stopped by time limit, it is *cancelled* and the `isCancelled` flag is set.

#### Return value
The return value is true when the operation is started without any errors.

### `waitOperations`
Wait until all operations are finished or cancelled.
````
queue.waitOperations()
````

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
