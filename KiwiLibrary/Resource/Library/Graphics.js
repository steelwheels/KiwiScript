/* Graphics.js */

// func InsetRect(rect: Rect, dx:Double, dy:Double) -> Rect
function insetRect(rect, dx, dy) {
	const newx      = rect.x + dx ;
	const newy      = rect.y + dy ;
	const newwidth  = max(rect.width  - 2.0 * dx, 0.0) ;
	const newheight = max(rect.height - 2.0 * dy, 0.0) ;
	return Rect(newx, newy, newwidth, newheight) ;
}
