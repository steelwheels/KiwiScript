/*
 * GraphicsPrimitive.js
 */

class Point {
	constructor(x, y) {		// (Double, Double)
		this.x = x ;
		this.y = y ;
	}

	get description() {
		return "(x:" + this.x + ", y:"+ this.y + ")" ;
	}
}

class Size {
	constructor(width, height) {	// (Double, Double)
		this.width  = width ;
		this.height = height ;
	}

	get description() {
		return "(w:" + this.width + ", h:"+ this.height + ")" ;
	}
}

class Rect {
	constructor(origin, size) {	// (Point, Size)
		this.origin = origin ;
		this.size   = size ;
	}

	get description() {
		return "(" + this.origin.description + ", " + this.size.description + ")" ;
	}
}
