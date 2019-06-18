/*
 * Graphics.js
 */

class NodeAction {
	constructor(visible, speed, angle){
		this.mVisible	= visible ;	// Bool
		this.mSpeed	= speed ;	// Double [m/sec]
		this.mAngle	= angle ;	// Double [radian]
	}
	get visible()	{ return this.mVisible ;	}
	get speed()	{ return this.mSpeed ;		}
	get angle()	{ return this.mAngle ;		}
}

class NodeStatus {
	constructor(pos, size){
		this.mPosition	= pos ;		// Point
		this.mSize	= size ;	// Size
	}
	get position()	{ return this.mPosition ;	}
	get size()	{ return this.mSize ;		}
}

