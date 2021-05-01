"use strict";
/* File.js */
/// <reference path="types/Builtin.d.ts"/>
class File {
    constructor(core) {
        this.mCore = core;
    }
    getc() {
        while (true) {
            let c = this.mCore.getc();
            if (c != null) {
                return c;
            }
        }
    }
    getl() {
        while (true) {
            let c = this.mCore.getl();
            if (c != null) {
                return c;
            }
        }
    }
    put(str) {
        this.mCore.put(str);
    }
}
const stdin = new File(_stdin);
const stdout = new File(_stdout);
const stderr = new File(_stderr);
