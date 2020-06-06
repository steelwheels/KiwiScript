# TSON: Typed Script Object Notation
## Introduction
This document describes about the specification of
the _Typed Script Object Notation_ .
The typed script object notation is resemble to [JSON](https://www.json.org/json-en.html). But it support following definitions
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

## Overview
### Comments
The context between `//` and newline (or end of file) is treated as comment. It will be removed by the parser.

### Data type
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

### Parameters
The parameter definition is supported to define the function.
The definition is _optional_. If it is defined following value will be a body of function. In usually, the free-text is used to define the body.
````
{
        func-name: return-type (param0: type0, param1: type1) %{
                ... function body ...
        %}
}
````

### Value declaration
The special symbol is used to present free text.
Put the text between `%{` and `%}`.

## Syntax
The comment must be removed before parsing.
````
tson_object       := object_notation
object_notation   := '{' property_list '}'
property_list     := property [',' property]*
property          := identifier ':' type_declaration value_declaration
identifier        := <usual string>
type_declaration  := "bool" | "int" | "float" | "string"
value_declaration :=   primitive_declaration
                     | string_declaration
                     | function_declaration
````

## Related links
* [Steel Wheels Project](https://steelwheels.github.io): The developer's web page
