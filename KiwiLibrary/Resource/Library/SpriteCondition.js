/*
 * SpriteCondition.js
 */

class SpriteCondition {
	constructor(cdamage){
		checkVariables("SpriteCondition.constructor", cdamage) ;
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
