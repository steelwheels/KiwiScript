/*
 * Graphics.js
 */

class SpriteNodeAction {
	constructor(active, speed, angle){
		checkVariables("SpriteNodeAction.constructor", active, speed, angle) ;
		this.mActive	= active ;	// Bool
		this.mSpeed	= speed ;	// Double [m/sec]
		this.mAngle	= angle ;	// Double [radian]
	}
	get active()	{ return this.mActive ;		}
	get speed()	{ return this.mSpeed ;		}
	get angle()	{ return this.mAngle ;		}

	// toParameter() -> Object
	toParameter() {
		let obj = {
			active:		this.mActive,
			speed: 		this.mSpeed,
			angle: 		this.mAngle
		} ;
		return obj ;
	}
}

class SpriteNodeStatus {
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

class SpriteCondition {
	constructor(cdamage){
		checkVariables("SpriteCondition.constructor", cdamage)
		this.mCollisionDamage = cdamage ;
	}

	// collosionDamage -> Double
	get collisionDamage() { return this.mCollisionDamage ; }
	set collisionDamage(newval) {
		if(checkVariables(newval)) {
			this.mCollisionDamage = newval ;
		}
	}

	// toParameter() -> Object
	toParameter() {
		let obj = {
			collisionDamage: this.mCollisionDamage
		} ;
		return obj ;
	}
}
