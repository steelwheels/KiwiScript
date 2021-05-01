/* File.js */

/// <reference path="types/Builtin.d.ts"/>

const EOF : number = -1 ;

class File
{
    mCore : _File ;

    constructor(core : _File){
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
declare var _stdin:  _File ;
declare var _stdout: _File ;
declare var _stderr: _File ;

const stdin  = new File(_stdin) ;
const stdout = new File(_stdout) ;
const stderr = new File(_stderr) ;

