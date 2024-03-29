"use strict";
/* Math.ts */
/// <reference path="types/Enum.d.ts"/>
/// <reference path="types/Intf.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>
;
/* Convert value to integer */
function int(value) {
    return Math.floor(value);
}
/* randomInt: Get random integer value between min and max */
Math.randomInt = function (min, max) {
    const range = max - min + 1;
    const rval = Math.floor(Math.random() * range);
    return rval + min;
};
/* clamp: Clip the source value with minimum/maximum value */
Math.clamp = function (src, min, max) {
    if (src < min) {
        return min;
    }
    else if (src > max) {
        return max;
    }
    else {
        return src;
    }
};
function compareNumbers(n0, n1) {
    if (n0 < n1) {
        return ComparisonResult.ascending;
    }
    else if (n0 == n1) {
        return ComparisonResult.same;
    }
    else {
        return ComparisonResult.descending;
    }
}
function compareStrings(s0, s1) {
    if (s0 < s1) {
        return ComparisonResult.ascending;
    }
    else if (s0 == s1) {
        return ComparisonResult.same;
    }
    else {
        return ComparisonResult.descending;
    }
}
