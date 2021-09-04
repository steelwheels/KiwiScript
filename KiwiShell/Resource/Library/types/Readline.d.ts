/// <reference path="KiwiLibrary.d.ts" />
/// <reference path="Builtin.d.ts" />
declare type MenuItem = {
    key: string;
    label: string;
};
declare class ReadlineObject {
    constructor();
    inputLine(): string;
    inputInteger(): number;
    menu(items: MenuItem[]): number;
    stringsToMenuItems(labels: string[], doescape: boolean): MenuItem[];
}
declare const Readline: ReadlineObject;
