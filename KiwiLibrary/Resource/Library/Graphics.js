/* Graphics.js */

class Graphics {
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
}
