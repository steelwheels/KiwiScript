# Thread function

## `thread` function
Execute JavaScript callback function on the other thread.

### Prototype
````
thread(func: Function(), input: File, output: File, error: File) -> Thread
````

### Description
The [File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) or [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) object can be used. If the `Pipe` object is passed for `output` or `error` parameter, the write file handler of the pipe is *closed* when the process is finished.

### Parameter(s)
|Name           |Type   |Description                    |
|:---           |:----  |:----                          |
|func           |Function() |Function to execute on the thread.    |      
|input          |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) or [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) |Input file stream |
|output         |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) or [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) |Output file stream |
|error          |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) or [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) |Output error stream |

### Return value
When the thread has been launched with no errors,
the return value is instance of [Thread class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Thread.md).
When it failed, the return value will be `null`.

## References
* [Thread class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Thread.md): The object to present the status of the thread.
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* BSD Library Reference Manual: Manual page on macOS.
