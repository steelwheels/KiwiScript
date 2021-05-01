/// <reference path="Builtin.d.ts" />
declare class File {
    mCore: _File;
    constructor(core: _File);
    getc(): string;
    getl(): string;
    put(str: string): void;
}
declare var _stdin: _File;
declare var _stdout: _File;
declare var _stderr: _File;
declare const stdin: File;
declare const stdout: File;
declare const stderr: File;
