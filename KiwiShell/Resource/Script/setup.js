/* setup.js */

function main(args)
{
	if(FileManager.setupFileSystem()) {
		console.print("Setup file system ... done\n") ;
	} else {
		console.print("Setup file system ... failed\n") ;
	}
	return 0
}
