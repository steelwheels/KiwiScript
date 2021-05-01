/// <reference path="Builtin.d.ts" />
declare function Array1D(length: number, value: any): any[];
declare function Array2D(width: number, height: number, value: any): any[][];
declare class Table {
    mWidth: number;
    mHeight: number;
    mTable: any[][];
    get width(): number;
    get height(): number;
    constructor(width: number, height: number);
    isValid(x: number, y: number): boolean;
    element(x: number, y: number): any | null | undefined;
    setElement(x: number, y: number, value: any | null): void;
    fill(value: any | null): void;
    forEach(childFunc: (value: any, index: _Point) => void): void;
    forEachColumn(x: number, childFunc: (value: any, y: number) => void): void;
    forEachRow(y: number, childFunc: (value: any, x: number) => void): void;
    find(findFunc: (value: any, index: _Point) => boolean): void;
    findIndex(findFunc: (value: any, index: _Point) => boolean): _Point;
    map(mapFunc: (value: any, index: _Point) => any): Table;
    toStrings(elm2str: (value: any, index: _Point) => any): string[];
}
