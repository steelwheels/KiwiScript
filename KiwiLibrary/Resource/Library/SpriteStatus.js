/*
 * SpriteStatus.js
 */

class SpriteNodeStatus
{
	constructor(pos, size, energy){
		checkVariables("SpriteNodeStatus.constructor", pos, size, energy) ;
		this.mPosition	= pos ;		// Point
		this.mSize	= size ;	// Size
		this.mEnergy	= energy ;	// Double
	}
	get position()	{ return this.mPosition ;	}
	get size()	{ return this.mSize ;		}
	get energy()    { return this.mEnergy ;		}

	// toParameter() -> Object
	toParameter() {
		let obj = {
			position:	this.mPosition,
			size:		this.mSize,
			energy:		this.mEnergy
		} ;
		return obj ;
	}
}
