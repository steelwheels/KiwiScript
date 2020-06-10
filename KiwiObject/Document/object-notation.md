# ASON: Amber Script Object Notation
## Introduction
This document describes about the specification of
the _Amber Script Object Notation_.
The it is resemble to [JSON](https://www.json.org/json-en.html),
but it is extended to improve readability and writability.
There are modified points:
* The `//` comment is supported. The string between `//` and end-of-line will be ignored
* The double quotation for the property key is NOT required.

Here is the example of KSON data:
````
{   
        // This is object of Point class   
        class:  "Point",
        x:      10,
        y:      20
}
````

## Overview
### Comments
The context between `//` and newline (or end of file) is treated as comment. It will be removed by the parser.

## Properties
The property key is described by identifier instead of string.
````
{
        name: 10        // Do not use "name" for property name
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
                |  number
                |  object
                |  array
                |  bool
                |  'null'
array           := '[' [values] ']'
values          := value
                |  values ',' value

````

## Related links
* [Steel Wheels Project](https://steelwheels.github.io): The developer's web page
* [KiwiObject Framework](https://github.com/steelwheels/KiwiScript/tree/master/KiwiObject): The framework which contains this document
