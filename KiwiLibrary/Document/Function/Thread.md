# Thread function

## `thread` function
Execute JavaScript callback function on the other thread.

### Prototype
````
thread(func: Function(), input: File, output: File, error: File) -> Thread
````
### Parameter(s)
|Name           |Type   |Description                    |
|:---           |:----  |:----                          |
|func           |Function() |Function to execute on the thread.    |      
|input          |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) |Input file stream |
|output         |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) |Output file stream |
|error          |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) |Output error stream |

### Return value
When the thread has been launched with no errors,
the return value is instance of [Thread class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Thread.md).
When it failed, the return value will be `null`.

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* BSD Library Reference Manual: Manual page on macOS.

