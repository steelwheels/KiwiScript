"use strict";
/* Math.ts */
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
