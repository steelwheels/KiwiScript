# Preference
The *Preference* class is used access system preference values.

## Global variables
The singleton object is defined for Preference class.

|Variable       |Class      | Description                   |
|:---           |:---       |:---                           |
|`Preference`   |Preference |Singleton object of the class  |

## `system` preference
The preference of system software such as OS, base application.

This is a list of properties in the preference:
|Name       |Type       |Description                        |
|:---       |:---       |:---                               |
|`version`  |String     |The version of the application     |

Here is examples to acceess property.
````
let version_string = Preference.system.version ;
````

## `shell` preference
*This preference is exist only in interractive mode in shell.* This has properties for shell operation.

This is a list of properties in the preference:
|Name       |Type       |Description                        |
|:---       |:---       |:---                               |
|`prompt`   |Function   |The function to generate prompt string |

Here is examples to acceess property.
````
Preference.shell.prompt = function() {
    return "JSH" ;
}
````

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
