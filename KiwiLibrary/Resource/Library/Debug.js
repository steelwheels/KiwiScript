"use strict";
/**
 * Debug.ts
 */
/// <reference path="types/Builtin.d.ts"/>
function checkVariables(place, ...vars) {
    let result = true;
    vars.forEach(function (value, index) {
        if (isUndefined(value)) {
            console.log("check at " + place + ": Undefined at index " + index);
            result = false;
        }
        else if (isNull(value)) {
            console.log("check at " + place + ": Null at index " + index);
            result = false;
        }
    });
    return result;
}
