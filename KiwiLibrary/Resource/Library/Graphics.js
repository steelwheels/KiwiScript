/*
 * Graphics.js
 */

// addPoint(p0: Point, p1: Point) -> Point
function addPoint(p0, p1){
	return Point(p0.x + p1.x, p0.y + p1.y) ;
}

// clampPoint(src: Point, x: Float, y: Float, width: Float, height: Float)
function clampPoint(src, x, y, width, height) {
	let newx = Math.clamp(src.x, x, x + width) ;
	let newy = Math.clamp(src.y, y, y + height) ;
	return Point(newx, newy) ;
}


