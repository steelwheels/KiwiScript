"use strict";
/*
 * Primitive data structures
 */
/// <reference path="types/Builtin.d.ts"/>
function tableInStorage(storage, path) {
    let strg = Storage(storage);
    if (strg == null) {
        console.error("[Error] Storage " + storage + " is Not Exist\n");
        return null;
    }
    return Table(path, strg);
}
