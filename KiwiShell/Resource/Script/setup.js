/* setup.js */

function main(args)
{
        console.log("Hello from setup") ;
	if(FileManager.setupFileSystem()) {
		console.print("Setup file system ... done\n") ;
	} else {
		console.print("Setup file system ... failed\n") ;
	}
	return 0
}
