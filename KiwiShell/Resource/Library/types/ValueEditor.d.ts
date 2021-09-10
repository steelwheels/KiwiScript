/// <reference path="KiwiLibrary.d.ts" />
/// <reference path="Builtin.d.ts" />
/// <reference path="Readline.d.ts" />
declare class ValueEditor {
    edit(val: any): any | null;
    editBool(val: boolean): boolean | null;
    editNumber(val: number): number | null;
    editString(val: string): string | null;
    editDictionary(val: {
        [name: string]: any;
    }): {
        [name: string]: any;
    } | null;
    editArray(val: string[]): string[] | null;
    inputBool(msg: string): boolean | null;
    inputNumber(msg: string): number | null;
    inputString(msg: string): string | null;
    check(message: string): boolean;
}
