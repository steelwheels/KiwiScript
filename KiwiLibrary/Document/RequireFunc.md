# Require: JavaScript module manager
This document describes about `require` built-in function. The function is used to manage built-in.

## Built-in function: `Require`
````
var retobj = require("module-path") ;
````

### Parameter(s)
|Parameter    |Type   |Description                    |
|:---         |:---   |:---                           |
|module-path  |String |Path of the module             |

The module is chosen by given "path".
For more details, see "Method to search module" section.

### Return value
The top level object allocated for the module. If the allocation is failed, this value will be *null*.

### Method to search module
The `require` function choose the module by given "path".
This section describes about the method to search the module by the path.

There are 3 kind of modules:
1. *Built-in module*: The module which is embedded in the command binary.
2. *System module*: The JavaScript library which is distributed in this application.
3. *User module*: The JavaScript library which is implemented by the developer.

#### Built-in modules
If the given "path" string is equals to the module name, the module will be chosen. The document [Built-in modules](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md) has the list of them.

#### System Modules
Not supported yet.

#### User Modules
Not supported yet.

## Related link
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/tree/master/KiwiLibrary): Top level document
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
