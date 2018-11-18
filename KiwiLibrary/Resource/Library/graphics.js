/*
 * GraphicsPrimitive.js
 */

class Point {
	constructor(x, y) {		// (Double, Double)
		this.x = x ;
		this.y = y ;
	}
}

class Size {
	constructor(width, height) {	// (Double, Double)
		this.width  = width ;
		this.height = height ;
	}
}

class Rect {
	constructor(origin, size) {	// (Point, Size)
		this.origin = origin ;
		this.size   = size ;
	}
}
