/*
 * cd.js
 */

function main(args)
{
	if(args.length > 0) {
		let path   = args[0] ;
		let result = 1 ;
		switch(FileManager.checkFileType(path)) {
			case FileType.notExist:
				console.error("cd: no such file or directory: " + path + "\n") ;
			break ;
			case FileType.file:
				console.error("cd: not a directory: " + path + "\n") ;
			break ;
			case FileType.directory:
				//console.error("cd: " + path + "\n") ;
				if(FileManager.isAccessible(path, AccessType.read)) {
					Environment.set("PWD", path) ;
					result = 0 ;
				} else {
					console.error("cd: can not read the directory: " + path + "\n")
				}
			break ;
			default:
				console.error("cd: no such file or directory: " + path + "\n") ;
			break ;
		}
		return result ;
	} else {
		Environment.set("PWD", FileManager.homeDirectory()) ;
		return 0 ;
	}



}

