/**
 * Debug.js
 */

function checkVariables(place, ...vars)
{
	vars.forEach(function(value, index){
	    if(isUndefined(value)){
		     console.log("check at " + place + ": Undefined at index " + index + "\n") ;
	    } else if(isNull(value)) {
		     console.log("check at " + place + ": Null at index " + index + "\n") ;
	    }
	}) ;
}
