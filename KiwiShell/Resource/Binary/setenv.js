/*
 * setenv.js
 */

function main(args)
{
	let result = -1 ;
	if(args.length == 2) {
		let name  = args[0] ;
		let value = args[1] ;
		if(isString(name)) {
			Environment.set(name, value.toString()) ;
			result = 0 ;
		} else {
			console.error("getenv: Unacceptable variable name\n") ;
		}
	} else {
		console.error("getenv: Invalid number of parameters\n") ;
	}
	return result ;
}

