/// <reference path="Builtin.d.ts" />
declare function _waitUntilExitOne(process: _Process): number;
declare function _waitUntilExitAll(processes: _Process[]): number;
declare class Semaphore {
    mValue: _Dictionary;
    constructor(initval: number);
    signal(): void;
    wait(): void;
}
declare class CancelException extends Error {
    code: number;
    constructor(code: number);
}
declare function _cancel(): void;
declare function openPanel(title: string, type: number, exts: string[]): _URL | null;
declare function run(path: _URL | string | null, input: _File, output: _File, error: _File): object | null;
