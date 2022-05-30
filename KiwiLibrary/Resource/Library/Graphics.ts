/*
 * Graphics.ts
 */

/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Math.d.ts"/>
/// <reference path="types/Enum.d.ts"/>

function addPoint(p0: PointIF, p1: PointIF): PointIF {
	return Point(p0.x + p1.x, p0.y + p1.y) ;
}

function isSamePoints(p0: PointIF, p1: PointIF): boolean {
        return p0.x == p1.x && p0.y == p1.y ;
}

function clampPoint(src: PointIF, x: number, y: number,
					width: number, height: number): PointIF {
	let newx: number = Math.clamp(src.x, x, x + width  - 1) ;
	let newy: number = Math.clamp(src.y, y, y + height - 1) ;
	return Point(newx, newy) ;
}

