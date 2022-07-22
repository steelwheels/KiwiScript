# Run function

## `run` function
Load or select JavaScript file and execute on the new thread.
When the file name is `nil`, the file selector panel is opened (macOS only).
The return value is an instance of [Thread class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Thread.md).

### Prototype
````
run(path: String, input: File, output: File, error: File) -> Thread
````

### Description
At 2nd, 3rd and 4th parameter. the [File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) or [Pipe](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) object can be used. If the `Pipe` object is passed for `input`, `output` and `error` parameter, the write file handler of the pipe is *closed* when the process is finished.

### Parameter(s)
|Name           |Type   |Description                    |
|:---           |:----  |:----                          |
|path           |String? |The file path of the source script or [package](https://github.com/steelwheels/JSTools/blob/master/Document/jsh-man.md). When this value is *null*, the file open panel is used to select the script (or package).  |
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
