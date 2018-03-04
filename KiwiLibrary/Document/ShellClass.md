# Shell operation
The *Shell class* is used to execute command line application from the JavaScript.

## Global variables
Following global variables are defined when this class is imported.

|Variable   |Class   | Description                     |
|:---       |:---    |:---                             |
|Shell      |Shell   | Singleton object of Shell class  |

## Shell Class

### The `execute` class method
Execute the other application asynchronously.
````
  let process = Shell.execute(command, infile, outfile, errfile) ;
````
#### Parameter(s)

|Parameter |Type       |Description       |
|:--       |:---       |:---              |
|command   |String     |The command to execute on the shell. It has command line application and following options and arguments such as "`/bin/ls -l`"|
|infile    |FileObject |See [File Object Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/FileClass.md). In usually, the `stdin` is used for standard input.|
|outfile   |FileObject |See [File Object Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/FileClass.md).In usually, the `stdout` is used for standard output.|
|errfile   |FileObject |See [File Object Class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/FileClass.md). In usually, the `stderr` is used for standard error.|

#### Return Value
The instance of [Process Object](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/ProcessClass.md) is returned when the given command is started. Otherwise, this value will be `null`.

### The `searchCommand` class method
````
  let pathstr = Shell.searchCommand(commandname) ;
````

#### Parameter(s)

|Parameter   |Type       |Description       |
|:--         |:---       |:---              |
|commandname |String     |Name of the command line application such as "`ls`".|

#### Return Value
The string object which presents the path of the given command is returned when the command is found. Otherwise, this value will be `null`.

## Related link
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/tree/master/KiwiLibrary): Top level document
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
