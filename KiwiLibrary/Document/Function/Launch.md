# Launch function

## `launch` function
Launch the macOS application with/without any document.
You can launch the application by the application name or the document name.
The return value is an instance of [Application class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Application.md).

### Prototype
````
launch(app: URL?, doc: URL?) -> Application
````

### Description
You can launch the application by it's name or document for it.
You have to give non-null value whether `app` or `doc`.  

### Parameter(s)
|Name   |Type                 |Description                    |
|:---   |:----                |:----                          |
|app    |URL \| String \| nil |The file path of the application |
|doc    |URL \| String \| nil |The file path of the document |

### Return value
When the application has been launched with no errors,
the return value is instance of [Application class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Application.md).
When it failed, the return value will be `null`.

## References
* [Application class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Application.md): The object to present the status of the thread.
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* BSD Library Reference Manual: Manual page on macOS.
