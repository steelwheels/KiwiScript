# Console class
The *Console* class is used to print text to console.

## Global variable
The singleton object is defined for Console class.

|Variable   |Class    | Description                     |
|:---       |:---     |:---                             |
|console    |Console  |Singleton object of Console class  |


## Sample
````
function main(args : string[]): number
{
	console.print("Hello to print\n") ;
	console.error("Hello to error\n") ;
	console.log("Hello to log\n") ;
	return 0 ;
}
````

This is terminal to put standard output and standard error:
![console.print](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Images/console-print.png)

This is console to output the log:
![console.log](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Images/console-log.png)

## `print` method
Print the message to standard output.
````
console.print(message: string): void
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|message      |String |Log message string             |

### Return value
none

## `error` method
Print the message to standard error.
````
console.error(message: string): void
````
### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|message      |String |Error message string           |

### Return value
none

## `log` method
Print the message to log window. If the window is not opened. This method will open it.
````
console.log(message: string): void
````

The log window is shared by multiple windows. So the log message from multiple windows and terminals *will be mixed*.
  
#### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|message      |String |Error message string           |

### Return value
none

## References
* [Debug class](Console.md): The `Debug` class
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
