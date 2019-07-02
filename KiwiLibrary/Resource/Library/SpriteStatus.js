/*
 * SpriteStatus.js
 */

class SpriteNodeStatus
{
	// constructor(uniqid: Int, teamid:Int, pos:Point, size:Size, energy: Double)
	constructor(uid, tid, pos, size, energy){
		checkVariables("SpriteNodeStatus.constructor", uid, tid, pos, size, energy) ;
		this.mUniqueId  = uid ;
		this.mTeamId    = tid ;
		this.mPosition	= pos ;
		this.mSize	= size ;
		this.mEnergy	= energy ;
	}
	get uniqueId()  { return this.mUniqueId ;		}
	get teamId()    { return this.mTeamId ;		}
	get position()	{ return this.mPosition ;	}
	get size()	{ return this.mSize ;		}
	get energy()    { return this.mEnergy ;		}

	// toParameter() -> Object
	toParameter() {
		let obj = {
			uniqueId:	this.mUniqueId,
			teamId:		this.mTeamId,
			position:	this.mPosition,
			size:		this.mSize,
			energy:		this.mEnergy
		} ;
		return obj ;
	}
}
