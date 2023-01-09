"use strict";
/*
 * String.ts
 */
/// <reference path="types/Enum.d.ts"/>
/// <reference path="types/Intf.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>
function maxLengthOfStrings(strs) {
    let result = 0;
    for (let str of strs) {
        result = Math.max(result, str.length);
    }
    return result;
}
function adjustLengthOfStrings(strs) {
    let maxlen = maxLengthOfStrings(strs);
    let result = [];
    for (let str of strs) {
        let len = str.length;
        if (len < maxlen) {
            let spaces = " ".repeat(maxlen - len);
            result.push(str + spaces);
        }
        else {
            result.push(str);
        }
    }
    return result;
}
function pasteStrings(src0, src1, space) {
    let cnt0 = src0.length;
    let cnt1 = src1.length;
    if (cnt0 > 0 && cnt1 > 0) {
        let msrc0 = adjustLengthOfStrings(src0);
        let msrc1 = adjustLengthOfStrings(src1);
        let mlen0 = msrc0[0].length;
        let mlen1 = msrc1[0].length;
        let maxcnt = Math.max(cnt0, cnt1);
        if (cnt0 < maxcnt) {
            let empty = " ".repeat(mlen0);
            let lns = maxcnt - cnt0;
            for (let i = 0; i < lns; i++) {
                msrc0.push(empty);
            }
        }
        if (cnt1 < maxcnt) {
            let empty = " ".repeat(mlen1);
            let lns = maxcnt - cnt1;
            for (let i = 0; i < lns; i++) {
                msrc1.push(empty);
            }
        }
        let result = [];
        for (let i = 0; i < maxcnt; i++) {
            let line = msrc0[i] + space + msrc1[i];
            result.push(line);
        }
        return result;
    }
    else if (cnt0 > 0) { // cnt1 == 0
        return adjustLengthOfStrings(src0);
    }
    else if (cnt1 > 0) { // cnt0 == 0
        return adjustLengthOfStrings(src1);
    }
    else {
        return [];
    }
}
function isEqualTrimmedStrings(str0, str1) {
    let str0t = str0.trim().toUpperCase();
    let str1t = str1.trim().toUpperCase();
    return str0t == str1t;
}
