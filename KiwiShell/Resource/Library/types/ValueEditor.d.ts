/// <reference path="KiwiLibrary.d.ts" />
/// <reference path="Builtin.d.ts" />
/// <reference path="Readline.d.ts" />
declare class ValueEditor {
    editDictionary(val: {
        [name: string]: string;
    }): {
        [name: string]: string;
    } | null;
    editString(val: string): string | null;
    checkToReplace(): boolean;
}
