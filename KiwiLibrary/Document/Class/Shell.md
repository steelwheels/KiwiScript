# Shell Class
The *Shell class* is used to execute command line application from the JavaScript.

## The `execute` class method
Execute the other application asynchronously.
````
  let process = Shell.execute(command, infile, outfile, errfile) ;
````
### Parameter(s)

|Parameter |Type       |Description       |
|:--       |:---       |:---              |
|command   |String     |The command to execute on the shell. It has command line application and following options and arguments such as "`/bin/ls -l`"|
|infile    |*1 |Input data stream |
|outfile   |*1 |Output data stream|
|errfile   |*1 |Error stream|

The type "\*1" presents the data stream object: [File Object Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/File.md) or [Pipe Object Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md).
If you want to connect the stream into the other shell execution, use the *Pipe Object*.
On the other hand, the *File Object* will be used to read/write stream from/to the file.

### Return Value
The instance of [Process Object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/ProcessClass.md) is returned when the given command is started. Otherwise, this value will be `null`.

## The `searchCommand` class method
````
  let pathstr = Shell.searchCommand(commandname) ;
````

### Parameter(s)

|Parameter   |Type       |Description       |
|:--         |:---       |:---              |
|commandname |String     |Name of the command line application such as "`ls`".|

### Return Value
The string object which presents the path of the given command is returned when the command is found. Otherwise, this value will be `null`.

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

