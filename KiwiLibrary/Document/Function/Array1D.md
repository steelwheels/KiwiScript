# Array1D
Utility functions to operate 1D array.

## `Array1D`
Allocate 1D array data with initial value.
````
let array = Array1D(size) ;
````

|Parameter(s)   |Type   |Description                    |
|:--            |:--    |:--                            |
|size           |Int    |Size(= length) of array        |
|initval        |Any    |Initial value of all elements  |

## `removeFromArray1D`
Copy the array without target value.
````
let newarray = removeFromArray1D(src, value) ;
````

|Parameter(s)   |Type          |Description             |
|:--            |:--           |:--                     |
|src            |Array<Any>    |Source array            |
|value          |Any           |The value will be not-contained in result |

# Related links
* [Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The standard library
