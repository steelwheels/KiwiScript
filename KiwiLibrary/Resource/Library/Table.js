"use strict";
/*
 * Table operation
 */
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Enum.d.ts"/>
function tableInStorage(storage, path) {
    let strg = Storage(storage);
    if (strg != null) {
        return Table(path, strg);
    }
    else {
        console.error("[Error] Storage " + storage + " is Not Exist\n");
        return null;
    }
}
