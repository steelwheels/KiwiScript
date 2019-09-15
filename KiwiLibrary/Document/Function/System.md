# System functions

## `exit` function
Finish process with exit code.

### Prototype
````
exit(code: Int32) -> Void
````
### Parameter(s)
|Name |Type   |Description                      |
|:--- |:----  |:----                            |
|code |Int32  |Exit code                        |

## `system` function
Execute shell command.

### Prototype
````
system(command: String, input: File, output: File, error: File) -> Process
````
### Parameter(s)
|Name           |Type   |Description                    |
|:---           |:----  |:----                          |
|command        |String |Shell command to execute       |      
|input          |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) |Input file stream |
|output         |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) |Output file stream |
|error          |[File](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) |Output error stream |

### Return value
When the process to execute the command has been launched with no errors,
the return value is instance of [Process class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Process.md).
When it failed, the return value will be `null`.

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
