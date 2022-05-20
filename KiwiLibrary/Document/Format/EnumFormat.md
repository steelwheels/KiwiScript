# The format for `enum` type

## Format
The format to define enum types:
````
{
        enum: {
                type_name_0: {
                        memmer_name_0: integer0,
                        memmer_name_1: integer1,
                        memmer_name_2: integer2
                },
                type_name_1: {
                        ...
                }
                ...
        }
}
````
The value of enum is *integer*.

## Sample
The enum type named `color_t` is defined in the following example.
````
{
        enum: {
                color_t: {
                        red:            0,
                        green:          1,
                        blue:           2
                }
        }
}
````

## References
* [Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The contents of the library
* [KiwiLibrary framework](https://github.com/steelwheels/KiwiScript/tree/master/KiwiLibrary): The framework contains this document and implementation.
* [Steel Wheels Project](http://steelwheels.github.io): Developper's site

