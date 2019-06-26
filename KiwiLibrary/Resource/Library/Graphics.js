/*
 * Graphics.js
 */

class SpriteNodeAction {
	constructor(active, speed, angle){
		this.mActive	= active ;	// Bool
		this.mSpeed	= speed ;	// Double [m/sec]
		this.mAngle	= angle ;	// Double [radian]
	}
	get active()	{ return this.mActive ;	}
	get speed()	{ return this.mSpeed ;		}
	get angle()	{ return this.mAngle ;		}
}

class SpriteNodeStatus {
	constructor(pos, size){
		this.mPosition	= pos ;		// Point
		this.mSize	= size ;	// Size
	}
	get position()	{ return this.mPosition ;	}
	get size()	{ return this.mSize ;		}
}

