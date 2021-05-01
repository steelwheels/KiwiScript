/**
 * Debug.ts
 */

/// <reference path="types/Builtin.d.ts"/>

function checkVariables(place: string, ...vars: any[]): boolean
{
	let result: boolean = true ;
	vars.forEach(function(value, index){
		if(isUndefined(value)){
			console.log("check at " + place + ": Undefined at index " + index) ;
			result = false ;
		} else if(isNull(value)) {
			console.log("check at " + place + ": Null at index " + index) ;
			result = false ;
		}
	}) ;
	return result ;
}
