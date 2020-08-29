# LogLevel
The `LogLevel` is used to filtering the log message.
The `nolog` level supress all log messages and `detail` level allows to output all messages.

## Properties
* `nolog`       : Print no any kind of log
* `error`       : Print only error message
* `warning`     : Print above and warning message
* `debug`       : Print debug message
* `detail`      : Print all messages

## Example
````
let loglevel = LogLevel.warning ;
````

## Reference
* [The Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The library which contains the definition of `LogLevel`.
* [Steel Wheels Project](https://steelwheels.github.io): Developer's web page
