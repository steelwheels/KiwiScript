"use strict";
/*
 * Readline.ts
 */
/// <reference path="types/KiwiLibrary.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>
class _Readline {
    constructor() {
    }
    inputLine() {
        let line = null;
        while (line == null) {
            line = _readlineCore.input();
            sleep(0.1);
        }
        console.print("\n"); // insert newline after the input
        return line;
    }
    inputInteger() {
        let result = null;
        while (result == null) {
            let line = this.inputLine();
            let val = parseInt(line);
            if (!isNaN(val)) {
                result = val;
            }
        }
        return result;
    }
    menu(items) {
        let result = 0;
        let decided = false;
        while (!decided) {
            for (let i = 0; i < items.length; i++) {
                console.print(`${i}: ${items[i]}\n`);
            }
            console.print("number> ");
            let line = Readline.inputLine();
            let num = parseInt(line);
            if (!isNaN(num)) {
                if (0 <= num && num < items.length) {
                    result = num;
                    decided = true;
                }
                else {
                    console.error(`[Error] Unexpected value: ${num}\n`);
                }
            }
            else {
                console.error(`[Error] Not number value: ${line}\n`);
            }
        }
        return result;
    }
}
const Readline = new _Readline();
