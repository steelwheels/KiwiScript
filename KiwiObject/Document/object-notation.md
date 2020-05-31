# KSON: Kiwi Script Object Notation
## Introduction
The _Kiwi Script Object Notation_ is similar to [JSON](https://www.json.org/json-en.html).
Following features are added.
* The type declaration is added
* Add syntax to describe compound text

Here is the example of KSON data:
````
{
        var_a String: "My Name",
        func_a Function: %{
                for(i=0 ; i<10 ; i++){
                        console.log("Hello, world !!") ;
                }
        %}
}
````

You will notice:
* The　type `key` is limited to string type. The double quotation for the key is *not required* like `var_a`.
* The `String` and `Function` is type name of the value.
* The free style text can be defined in `%{` and `%}`.

## Data type
The name of data types are _not defined_ by the KSON.
You can define any names but following names are recommended
to present them.

|Type name      |Description                                            |
|:---           |:---                                                   |
|`Bool`         |Boolean type. The value must be `true` or `false`      |
|`Int`          |System defined interger type                           |
|`Char`         |Character                                              |
|`String`       |String                                                 |


## Value declaration
The special symbol is used to present any context string.
Put the text between `%{` and `%}`.

## Related links
* [Steel Wheels Project](https://steelwheels.github.io): The developer's web page
