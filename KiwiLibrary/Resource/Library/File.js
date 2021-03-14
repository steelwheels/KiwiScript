/* File.js */

const EOF = -1 ;

class File
{
    constructor(core){
        this.mCore = core ;
    }

    getc() {
        while(true){
            let c = this.mCore.getc() ;
            if(c != null) {
                return c ;
            }
        }
    }

    getl() {
        while(true){
            let c = this.mCore.getl() ;
            if(c != null) {
                return c ;
            }
        }
    }
}

/* Global variables */
stdin  = new File(_stdin) ;
stdout = new File(_stdout) ;
stderr = new File(_stderr) ;
