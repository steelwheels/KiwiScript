

# Graphics Library

This document describes about functions for graphics.
They are implemented as class methods of `Graphics` class.

## Graphics Functions
````
"use strict";
/*
 * Graphics.ts
 */
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Math.d.ts"/>
/// <reference path="types/Enum.d.ts"/>
function addPoint(p0, p1) {
    return Point(p0.x + p1.x, p0.y + p1.y);
}
function isSamePoints(p0, p1) {
    return p0.x == p1.x && p0.y == p1.y;
}
function clampPoint(src, x, y, width, height) {
    let newx = Math.clamp(src.x, x, x + width - 1);
    let newy = Math.clamp(src.y, y, y + height - 1);
    return Point(newx, newy);
}

````

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* [Steel Wheels Project](https://steelwheels.github.io): Developer's web site



