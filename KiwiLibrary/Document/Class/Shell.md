# Shell Class
The *Shell class* is used to execute command line application from the JavaScript.

## The `execute` class method
Execute the other application asynchronously.
````
  let process = Shell.execute(command, inpipe, outpipe, errpipe) ;
````
### Parameter(s)

|Parameter |Type       |Description       |
|:--       |:---       |:---              |
|command   |String     |The command to execute on the shell. It has command line application and following options and arguments such as "`/bin/ls -l`"|
|inpipe    |[Pipe Object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) | Input data stream |
|outpipe   |[Pipe Object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) |Output data stream|
|errpipe   |[Pipe Object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Pipe.md) |Error stream|

### Return Value
The instance of [Process Object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/ProcessClass.md) is returned when the given command is started. Otherwise, this value will be `null`.

## The `executeOnConsole` class method
This is similar to `execute` method but the parameters are different.
````
  let process = Shell.executeOnConsole(command, console) ;
````
### Parameter(s)
|Parameter |Type       |Description       |
|:--       |:---       |:---              |
|command   |String     |The command to execute on the shell. |
|console   |[Console](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Console.md)   |Use this console for input, output and error stream|

### Return Value
See `execute` method.

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
