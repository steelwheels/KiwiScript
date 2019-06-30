

# SpriteAction class
This is a built-in JavaScript library defined in the [KiwiFramework](https://github.com/steelwheels/KiwiScript/tree/master/KiwiLibrary).

````
/*
 * SpriteAction.js
 */

class SpriteNodeAction
{
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

````

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

