# Math class
The variable `Math` is JavaScriptCore native built-in singleton object.

## Constants
## `PI`
The constant for PI. The data type is `Double`.
````
const half_pi = PI / 2.0 ;
````

## Class methods
### `sin`, `cos`, `tan`
````
Math.sin(rad) ;
Math.cos(rad) ;
Math.tan(rad) ;
````

#### Parameter
|Name       |Type    |Description                  |
|:--        |:--     |:--                          |
|rad        |Double  |Angle value (Unit: radian)   |

#### Return value
Result of calculation typed `Double`.
When the parameter is NOT number, the return value is `undefined`.

### `asin`, `acos`
The `asin()` function computes the principal value of the arc sine of x.
The result is in the range [-pi/2, +pi/2].
The `acos()` function computes the principle value of the arc cosine of x.
The result is in the range [0, pi].

````
Math.asin(value ;
Math.acos(value) ;
````

#### Parameter
|Name       |Type       |Description                  |
|:--        |:--        |:--                          |
|x          |Double     |The value must be \|x\| <= 1.0 |

#### Return value
arc sine/arc cosine of parameter. The result is in the range [-pi/2, +pi/2] for arcsine and range [0, pi] for cosine.

### `atan2`
````
Math.atan2(y, x) ;
````

#### Parameter

|Name       |Type             |Description                  |
|:--        |:--              |:--                          |
|y          |Double           |Y position                   |
|x          |Double           |X position                   |

#### Return value
Result of calculation typed `Double`.
When the parameter is NOT number, the return value is `undefined`.

### `sqrt`
Returns the square root of the value.
````
Math.sqrt(src) ;
````

#### Parameter
|Name       |Type             |Description                  |
|:--        |:--              |:--                          |
|src        |Double           |Source value                  |

#### Return value
The square root of the source value.
When the parameter is NOT number, the return value is `undefined`.

### `randomInt`
Return the random value between given range/
````
let val = Math.randomInt(min, max) ;
````

#### Parameter
|Name       |Type       |Description                    |
|:--        |:--        |:--                            |
|min        |Int        |Minimum value                  |
|max        |Int        |Maximum value                  |

## References
* [Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* BSD Library Reference Manual: Manual page on macOS.
