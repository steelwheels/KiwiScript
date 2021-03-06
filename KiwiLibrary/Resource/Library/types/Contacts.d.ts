/// <reference path="Builtin.d.ts" />
/// <reference path="Process.d.ts" />
declare class Contacts {
    mIsLoaded: boolean;
    constructor();
    get recordCount(): number;
    load(): boolean;
    forEach(callback: (record: _ContactRecord) => void): void;
}
declare function ContactTable(): __ContactTable | null;
