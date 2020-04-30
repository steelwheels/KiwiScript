/* setup.js */

function main(args)
{
        console.log("Hello from setup") ;
        let resurl = FileManager.resourceDirectory("Library") ;
        console.log("Resource = " + resurl.path) ;
}
