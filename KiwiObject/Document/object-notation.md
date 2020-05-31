# KSON: Kiwi Script Object Notation
## Introduction
This document describes about the specification of
the _Kiwi Script Object Notation_ .
The kiwi script object notation is resemble to [JSON](https://www.json.org/json-en.html). But it support following definitions
* Data type
* Function
* Free text

Here is the example of KSON data:
````
{      
        var_a: string "My Name",
        func_a: int (a: int, b: int) %{
                return a + b ;
        %}
}
````

## Comments
The context between `//` and newline (or end of file) is treated as comment. It will be removed by the parser.

## Data type
Some primitive data types are already defined.

|Type name      |Description                                            |
|:---           |:---                                                   |
|`bool`         |Boolean type. The value must be `true` or `false`      |
|`int`          |Signed integer number                                  |
|`float`        |Floating point number                                  |
|`string`       |UTF8 String                                            |

You can use custom definitions. It is not parsed by KSON parser
and decoded by the semantics analyzer (which is not defined here).
````
{
        position: Point { x: int 0, y: int 0}
}
````

## Parameters
The parameter definition is supported to define the function.
The definition is _optional_. If it is defined following value will be a body of function. In usually, the free-text is used to define the body.
````
{
        func-name: return-type (param0: type0, param1: type1) %{
                ... function body ...
        %}
}
````

## Value declaration
The special symbol is used to present free text.
Put the text between `%{` and `%}`.

## Related links
* [Steel Wheels Project](https://steelwheels.github.io): The developer's web page
