/*
 * cd.js
 */

function main(args)
{
	let path   = args[0] ;
	if(isString(path)){
		let newpath = FileManager.normalizePath(Env.get("PWD"), path) ;
		if(FileManager.isDirectory(newpath)){
			Env.set("PWD", newpath.path) ;
			return 0
		}
	}
	return 1
}

