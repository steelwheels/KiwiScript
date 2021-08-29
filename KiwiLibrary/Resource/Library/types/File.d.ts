/// <reference path="Builtin.d.ts" />
declare class File {
    mCore: FileIF;
    constructor(core: FileIF);
    getc(): string;
    getl(): string;
    put(str: string): void;
}
declare var _stdin: FileIF;
declare var _stdout: FileIF;
declare var _stderr: FileIF;
declare const stdin: File;
declare const stdout: File;
declare const stderr: File;
interface JSONFileIF {
    read(file: FileIF): object | null;
    write(file: FileIF, src: object): boolean;
}
declare var _JSONFile: JSONFileIF;
declare class JSONFile {
    constructor();
    read(file: File): object | null;
    write(file: File, src: object): boolean;
}
