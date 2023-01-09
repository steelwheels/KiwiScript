"use strict";
/**
 * Debug.ts
 */
/// <reference path="types/Enum.d.ts"/>
/// <reference path="types/Intf.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>
function checkVariables(place, ...vars) {
    let result = true;
    vars.forEach(function (value, index) {
        if (isUndefined(value)) {
            console.print("check at " + place + ": Undefined at index " + index + "\n");
            result = false;
        }
        else if (isNull(value)) {
            console.log("check at " + place + ": Null at index " + index + "\n");
            result = false;
        }
    });
    return result;
}
