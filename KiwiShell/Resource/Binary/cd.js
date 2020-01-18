/*
 * cd.js
 */

function main(args)
{
	let path   = args[0] ;
	let result = 1
	if(isString(path)){
		if(FileManager.changeCurrentDirectory(path)){
			result = 0
		}
	}
	return result
}

