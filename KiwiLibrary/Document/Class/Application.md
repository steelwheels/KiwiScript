# Application Class

## Introduction
The `Application` class is used to watch the status of the macOS application which is launched by [launch function](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Launch.md).

## `name` property
Get the localized name of the application. When it can not be gotten, the value will be `null`.
````
let name = app.name ;
````

## `bundleIdentifier` property
Get the bundle identifier of the application. When it can not be gotten, the value will be `null`.
````
let name = app.bundleIdentifier ;
````

## `isRunning` method
This method returns true when the launched application still running.
````
let isrun = app.isRunning() ;
````

## `waitUntilExit` method
Wait until the application is finished.
The return value is exit code of the process.
````
let exitcode = app.waitUntilExit() ;
````

### Note
This function *IS NOT* supported by command line application such as *jsh* in [JSTools](https://github.com/steelwheels/JSTools/blob/master/README.md).

## References
* [launch function](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Function/Launch.md): The function to generate the thread.
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
