/* CUI.js */

class CObject
{
	/* construcor(origin: Point, size: Size) */
	constructor(origin, size) {
		this.parent				= null ;
		this.visible			= true ;
		this.origin 			= origin ;
		this.size				= size ;
		this.foregroundColor	= Color.black ;
		this.backgroundColor	= Color.white ;
	}

	get frame()		{ return Rect(this.origin.x, this.origin.y, this.size.width, this.size.height) ; }
	get left()		{ return this.origin.x ; 					}	
	get right()		{ return this.origin.x + this.size.width ; 	}
	get top()		{ return this.origin.y ;					}
	get bottom()	{ return this.origin.y + this.size.height ;	}

	/* func moveTo(x: Int, y: Int) */
	moveTo(x, y) {
		this.origin = Point(x, y) ;
	}

	/* func draw() */
	draw() {
		console.error("CObject: Not supported") ;
	}

	/* func erace() */
	hide() {
		let parent = this.parent ;
		if(parent != null) {
			Curses.foregroundColor = parent.foregroundColor ;
			Curses.backgroundColor = parent.backgroundColor ;
		} else {
			Curses.foregroundColor = this.foregroundColor ;
			Curses.backgroundColor = this.backgroundColor ;
		}
		let frame = this.frame ;
		Curses.fill(frame.x, frame.y, frame.width, frame.height, " ") ;
		this.visible = false ;
	}

	/* func drawRect(rect: Rect) */
	drawRect(rect) {
		/* Setup colors */
		Curses.foregroundColor = this.foregroundColor ;
		Curses.backgroundColor = this.backgroundColor ;
		/* Fill by spaces */
		Curses.fill(rect.x, rect.y, rect.width, rect.height, " ") ;
	}

	/* func sectRect(rect0: Rect, rect1: Rect) -> Rect? */
	sectRect(rect0, rect1) {
		let left0   = rect0.x ;
		let right0  = left0 + rect0.width ;
		let top0    = rect0.y ;
		let bottom0 = top0 + rect0.height ; 

		let left1   = rect1.x ;
		let right1  = left1 + rect1.width ;
		let top1    = rect1.y ;
		let bottom1 = top1 + rect1.height ; 

		let newleft   = Math.max(left0, left1) ;
		let newright  = Math.min(right0, right1) ; 
		let newtop    = Math.max(top0, top1) ;
		let newbottom = Math.min(bottom0, bottom1) ;
		if(newleft<newright && newtop<newbottom) {
			return Rect(newleft, newtop, newright - newleft, newbottom - newtop) ;
		} else {
			return null
		}
	}
}

class CComponent extends CObject
{
	constructor(origin, size) {
		super(origin, size) ;
		this.items = [] ;		/* : Array<CObject> 	*/
	}

	/* addItem(item: CObject) */
	addItem(item) {
		this.items.push(item) ;
		item.parent = this ;
	}

	draw() {
		/* Draw background */
		this.drawRect(this.frame) ;
		/* Draw items */
		for(let item of this.items) {
			item.draw() ;
		}
	}
}

class CLabel extends CObject
{
	/* constructor(origin: Point, size: Size) */
	constructor(origin, size) {
		super(origin, size) ;
		this.text   = "" ;
	}

	/* func drawInRect(parent: CObject) */
	draw() {
		if(this.parent != null) {
			let sect = this.sectRect(this.frame, this.parent.frame) ;
			if(sect != null) {
				this.drawRect(sect) ;
			}
		} else {
			this.drawRect(this.frame) ;
		}
	}
}

