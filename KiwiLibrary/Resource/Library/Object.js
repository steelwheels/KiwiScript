"use strict";
/* Object.ts */
function isEmptyString(str) {
    return (str.length == 0);
}
function isEmptyObject(obj) {
    let keys = Object.keys(obj);
    return (keys.length == 0);
}
