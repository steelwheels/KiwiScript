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
declare function openPanel(title: string, type: FileType, exts: string[]): URLIF | null;
declare function savePanel(title: string): URLIF | null;
declare function run(path: URLIF | string | null, input: FileIF, output: FileIF, error: FileIF): object | null;
declare var _stdin: FileIF;
declare var _stdout: FileIF;
declare var _stderr: FileIF;
declare function launch(path: URLIF | string | null): object | null;
