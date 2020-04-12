/*
 * getenv.js
 */

function main(args)
{
	let result = -1 ;
	if(args.length == 1) {
		let val = Environment.get(args[0]) ;
		if(isString(val)){
			console.log(val) ;
			result = 0 ;
		}
	} else {
		console.error("getenv: Invalid number of parameters\n") ;
	}
	return result ;
}

