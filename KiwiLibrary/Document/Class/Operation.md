

# Operation Class

## Introduction
The `Operation` class is used to execute JavaScript code on a thread. This is the sequence to execute the operation thread:
1. Allocate operation object. The URL of user script is passed as a parameter of the constructor.

## Boot sequence
### 0. User script
The operation is implemented as a sub class of `Operation class`.
Your code will be implemented as the sub class of this class.

````
/*
 * Operation.js : Define Operation class
 */

 class CancelException extends Error
 {
 	constructor (code){
 		super("CancelException") ;
 		this.code = code ;
 	}
 }

function _cancel() {
	throw new CancelException(ExitCode.exception) ;
}

/* This class must be inherited */
class Operation
{
	constructor(){
		this.parameters = {} ;
	}

	setParameter(name, value){
		this.parameters[name] = value ;
	}

	parameter(name){
		return this.parameters[name] ;
	}

	main(){
		try {
			this.execute() ;
		} catch(err){
			return err.code
		}
	}

	execute(){
		console.log("[Error] Operation.execute must be override\n") ;
		return 0 ;
	}

	cancel(){
		_cancel() ;
	}
}

function _set_operation(op, name, value)
{
	op.setParameter(name, value) ;
}

function _get_operation(op, name)
{
	return op.parameter(name) ;
}

function _exec_operation(op)
{
	op.main() ;
}


````
You must override `execute` method to execute it in a unique thread.
This method is called when the operation is put into the operation queue.

### 1. Allocate `Operation` instance
You put your JavaScript code into the application package.
The location of the file must be defined in the
[manifest file](https://github.com/steelwheels/Amber/blob/master/Document/ManifestFile.md).

````
let newoperation = Operation([url], console) ;
````

#### Parameters
|Name   |Type                  |Description                     |
|:---   |:---                  |:---                            |
|URLs    |Array<[URL](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/URL.md)> | Array of the URLs for user scripts. |
|console |[Console](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Console.md) | The console to output from the operation. If you pass `null` as this parameter, the current console is used. |

#### Return value
The operation object. When the allocation is failed,
`undefined` value will be returned.

### 2. Setup the `operation` object.
Set some properties before execute before executing main operation.

### 3. Enter the operation into the operation queue


## References
* [OperationQueue Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/OperationQueue.md)
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
