/*
 * SpriteCondition.js
 */

class SpriteCondition {
	// func constructor(givingCollisionDamage:Double, receivingCollisionDamage:Double)
	constructor(gcdamage, rcdamage, rrange){
		checkVariables("SpriteCondition.constructor", gcdamage, rcdamage, rrange) ;
		this.mGivingCollisionDamage    = gcdamage ;
		this.mReceivingCollisionDamage = rcdamage ;
		this.mRaderRange	       = rrange ;
	}

	// givingCollosionDamage -> Double
	get givingCollisionDamage() { return this.mGivingCollisionDamage ; }
	set givingCollisionDamage(newval) {
		if(checkVariables(newval)) {
			this.mGivingCollisionDamage = newval ;
		}
	}

	// receivingCollosionDamage -> Double
	get receivingCollisionDamage() { return this.mReceivingCollisionDamage ; }
	set receivingCollisionDamage(newval) {
		if(checkVariables(newval)) {
			this.mReceivingCollisionDamage = newval ;
		}
	}

	// raderRange -> Double
	get raderRange() { return this.mRaderRange ; }
	set raderRange(newval) {
		if(checkVariables(newval)) {
			this.mRaderRange = newval ;
		}
	}

	// toParameter() -> Object
	toParameter() {
		let obj = {
			givingCollisionDamage:    this.mGivingCollisionDamage,
			receivingCollisionDamage: this.mReceivingCollisionDamage,
			raderRange:		  this.mRaderRange
		} ;
		return obj ;
	}
}

