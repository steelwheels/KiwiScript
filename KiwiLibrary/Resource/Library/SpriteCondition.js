/*
 * SpriteNodeCondition.js
 */

class SpriteNodeCondition {
	// func constructor(givingCollisionDamage:Double, receivingCollisionDamage:Double)
	constructor(gcdamage, rcdamage){
		checkVariables("SpriteNodeCondition.constructor", gcdamage, rcdamage) ;
		this.mGivingCollisionDamage    = gcdamage ;
		this.mReceivingCollisionDamage = rcdamage ;
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

	// toParameter() -> Object
	toParameter() {
		let obj = {
			givingCollisionDamage:    this.mGivingCollisionDamage,
			receivingCollisionDamage: this.mReceivingCollisionDamage
		} ;
		return obj ;
	}
}
