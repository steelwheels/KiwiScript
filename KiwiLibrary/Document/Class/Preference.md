# Preference
The *Preference* class is used access system preference values.

## Global variables
The singleton object is defined for Preference class.

|Variable       |Class      | Description                   |
|:---           |:---       |:---                           |
|`Preference`   |Preference |Singleton object of the class  |

## `system` preference
The preference of system software such as OS, base application.

### `version` property
Property to present the application version.
This is read only property.
````
let version_string = Preference.system.version ;
````

### Return value
String object.

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
