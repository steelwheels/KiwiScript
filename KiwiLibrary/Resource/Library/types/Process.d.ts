/// <reference path="Builtin.d.ts" />
/// <reference path="Enum.d.ts" />
declare function _waitUntilExitOne(process: ProcessIF): number;
declare function _waitUntilExitAll(processes: ProcessIF[]): number;
declare class Semaphore {
    mValue: {
        [key: string]: number;
    };
    constructor(initval: number);
    signal(): void;
    wait(): void;
}
declare class CancelException extends Error {
    code: number;
    constructor(code: number);
}
declare function _cancel(): void;
declare function openURL(url: URLIF | string): boolean;
declare function run(path: URLIF | string, args: string[], input: FileIF, output: FileIF, error: FileIF): number;
