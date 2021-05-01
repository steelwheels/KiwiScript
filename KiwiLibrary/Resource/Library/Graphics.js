"use strict";
/*
 * Graphics.ts
 */
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Math.d.ts"/>
function addPoint(p0, p1) {
    return Point(p0.x + p1.x, p0.y + p1.y);
}
function clampPoint(src, x, y, width, height) {
    let newx = Math.clamp(src.x, x, x + width);
    let newy = Math.clamp(src.y, y, y + height);
    return Point(newx, newy);
}
