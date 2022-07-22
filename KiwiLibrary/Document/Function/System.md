# System functions

## `system` function
Execute shell command.

### Prototype
````
system(command: String, input: File, output: File, error: File) -> Process
````

### Description
The [File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) or [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) object can be used. If the `Pipe` object is passed for `output` or `error` parameter, the write file handler of the pipe is *closed* when the process is finished.

### Parameter(s)
|Name           |Type   |Description                    |
|:---           |:----  |:----                          |
|command        |String |Shell command to execute       |
|input          |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) or [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) |Input file stream |
|output         |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) or [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) |Output file stream |
|error          |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) or [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) |Output error stream |

### Return value
When the process to execute the command has been launched with no errors,
the return value is instance of [Process class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Process.md).
When it failed, the return value will be `null`.

## References
* [Process class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Process.md): The class to present the status of the process.
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* BSD Library Reference Manual: Manual page on macOS.
