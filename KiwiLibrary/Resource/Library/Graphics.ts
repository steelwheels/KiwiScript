/*
 * Graphics.ts
 */

/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Math.d.ts"/>

function addPoint(p0: _Point, p1: _Point): _Point {
	return Point(p0.x + p1.x, p0.y + p1.y) ;
}

function isSamePoints(p0: _Point, p1: _Point): boolean {
        return p0.x == p1.x && p0.y == p1.y ;
}

function clampPoint(src: _Point, x: number, y: number,
					width: number, height: number): _Point {
	let newx: number = Math.clamp(src.x, x, x + width  - 1) ;
	let newy: number = Math.clamp(src.y, y, y + height - 1) ;
	return Point(newx, newy) ;
}

