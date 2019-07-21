/* Graphics.js */

class Graphics {
	// func distanceBetween2Points(p0:Point, p1:Point) -> Double
	static distanceBetween2Points(p0, p1) {
		const dx = p1.x - p0.x ;
		const dy = p1.y - p0.y ;
		return sqrt(dx*dx + dy*dy) ;
	}


	// func InsetRect(rect: Rect, dx:Double, dy:Double) -> Rect
	static insetRect(rect, dx, dy) {
		if(checkVariables("insetRect", rect, dx, dy)){
			const newx      = rect.x + dx ;
			const newy      = rect.y + dy ;
			const newwidth  = Math.max(rect.width  - 2.0 * dx, 0.0) ;
			const newheight = Math.max(rect.height - 2.0 * dy, 0.0) ;
			return Rect(newx, newy, newwidth, newheight) ;
		} else {
			return Rect(0.0, 0.0, 0.0, 0.0) ;
		}
	}

	// func centerOfRect(rect: Rect) -> Point
	static centerOfRect(rect){
		const x = rect.x + (rect.width  / 2.0) ;
		const y = rect.y + (rect.height / 2.0) ;
		return Point(x, y) ;
	}

	// func pointInFrame(point: Point, frame: Rect) -> Point
	static pointInFrame(point, frame){
		let x = point.x ;
		if(x < frame.x){
			x = frame.x ;
		} else if(frame.x + frame.width < x){
			x = frame.x + frame.width ;
		}
		let y = point.y ;
		if(y < frame.y){
			y = frame.y ;
		} else if(frame.y + frame.height < y){
			y = frame.y + frame.height ;
		}
		return Point(x, y) ;
	}
}
