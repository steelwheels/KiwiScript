/*
 * cd.js
 */

function main(args)
{
	if(args.length > 0) {
		let pathurl = FileManager.fullPath(args[0], Environment.currentDirectory) ;
		let pathstr = pathurl.path ;
		let result  = 1 ;
		switch(FileManager.checkFileType(pathurl)) {
			case FileType.notExist:
				console.error("cd: no such file or directory: " + pathstr + "\n") ;
			break ;
			case FileType.file:
				console.error("cd: not a directory: " + pathstr + "\n") ;
			break ;
			case FileType.directory:
				//console.error("cd: " + pathstr + "\n") ;
				if(FileManager.isAccessible(pathurl, AccessType.read)) {
					Environment.set("PWD", pathstr) ;
					result = 0 ;
				} else {
					console.error("cd: can not read the directory: " + pathstr + "\n")
				}
			break ;
			default:
				console.error("cd: no such file or directory: " + pathstr + "\n") ;
			break ;
		}
		return result ;
	} else {
		Environment.set("PWD", FileManager.homeDirectory().path) ;
		return 0 ;
	}



}

