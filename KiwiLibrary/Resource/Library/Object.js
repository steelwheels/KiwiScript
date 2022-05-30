"use strict";
/* Object.ts */
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Enum.d.ts"/>
function isEmptyString(str) {
    return (str.length == 0);
}
function isEmptyObject(obj) {
    let keys = Object.keys(obj);
    return (keys.length == 0);
}
