/*
 * SpriteStatus.js
 */

class SpriteNodeStatus
{
	// constructor(name: String, teamid:Int, pos:Point, size:Size, bounds:Rrct, energy: Double)
	constructor(name, tid, pos, size, bounds, energy){
		checkVariables("SpriteNodeStatus.constructor", name, tid, pos, size, bounds, energy) ;
		this.mName      = name ;
		this.mTeamId    = tid ;
		this.mPosition	= pos ;
		this.mSize	= size ;
		this.mBounds	= bounds ;
		this.mEnergy	= energy ;
	}
	get name()      { return this.mName ;		}
	get teamId()    { return this.mTeamId ;		}
	get position()	{ return this.mPosition ;	}
	get size()	{ return this.mSize ;		}
	get bounds()	{ return this.mBounds ;		}
	get energy()    { return this.mEnergy ;		}

	// toParameter() -> Object
	toParameter() {
		let obj = {
			name:		this.mName,
			teamId:		this.mTeamId,
			position:	this.mPosition,
			size:		this.mSize,
			bounds:		this.mBounds,
			energy:		this.mEnergy
		} ;
		return obj ;
	}
}
