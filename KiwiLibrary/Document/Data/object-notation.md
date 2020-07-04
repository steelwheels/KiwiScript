# JSONe: Extended JavaScript Object Notation
## Introduction
This document describes about the specification of
the _Extended JavaScript Object Notation_.
The `JSONe` is small extension of the [JSON](https://www.json.org/json-en.html).
It is extended to improve readability and writability.
There are modified points:
* The `//` comment is supported. The string between `//` and end-of-line will be ignored
* The double quotation for the property key is NOT required.
* Multi line string is supported. The string between `%{` and `%}` will be treated as string.

Here is the example of JSONe data:
````
{   
        // This is object of Point class   
        class:  "Point",
        x:      10,
        y:      20,
        description: %{
                The point class is used to present
                the "2D point".
        %}
}
````
The file extension of the JSONe file is `.jsobj`.

## Overview
Here is difference from JSON format.
### Comments
The context between `//` and newline (or end of file) is treated as comment. It will be removed by the parser.

### Properties
The property key is described by identifier instead of string.
````
{
        name: 10        //  "name" -> name
}
````

### Multi line string
The text between `%{` and `%}` is treated as string value.
````
{
        function: %{
                (a: Int, b: Int) -> Int in
                        return a + b
        %}
}
````


## Syntax
The comment must be removed before parsing.
````
object          := '{' [properties] '}'
properties      := property
                |  properties ',' property
property        := identifier ':' value
value           := string
                |  text
                |  number
                |  object
                |  array
                |  bool
                |  'null'
array           := '[' [values] ']'
text            := '%{' ...any characters... '%}'
values          := value
                |  values ',' value

````

## Related links
* [Steel Wheels Project](https://steelwheels.github.io): The developer's web page
* [KiwiObject Framework](https://github.com/steelwheels/KiwiScript/tree/master/KiwiObject): The framework which contains this document
