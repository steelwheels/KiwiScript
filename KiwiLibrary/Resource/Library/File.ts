/* File.js */

/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Enum.d.ts"/>

class File
{
    mCore : FileIF ;

    constructor(core : FileIF){
        this.mCore = core ;
    }

    getc(): string {
        while(true){
            let c = this.mCore.getc() ;
            if(c != null) {
                return c ;
            }
        }
    }

    getl(): string {
        while(true){
            let c = this.mCore.getl() ;
            if(c != null) {
                return c ;
            }
        }
    }

    put(str: string): void {
        this.mCore.put(str) ;
    }
}

/* Global variables */
declare var _stdin:  FileIF ;
declare var _stdout: FileIF ;
declare var _stderr: FileIF ;

const stdin  = new File(_stdin) ;
const stdout = new File(_stdout) ;
const stderr = new File(_stderr) ;

/* JSON file */
interface JSONFileIF {
	read(file: FileIF): object | null ;
	write(file: FileIF, src: object): boolean ;
}

declare var _JSONFile:		JSONFileIF ;

class JSONFile
{
	constructor(){
	}

	read(file: File): object | null {
		return _JSONFile.read(file.mCore) ;
	}

	write(file: File, src: object): boolean {
		return _JSONFile.write(file.mCore, src) ;
	}
}

