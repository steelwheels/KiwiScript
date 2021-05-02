/// <reference path="Builtin.d.ts" />
declare class CFrame {
    mFrame: _Rect;
    mCursorX: number;
    mCursorY: number;
    mForegroundColor: number;
    mBackgroundColor: number;
    constructor(frame: _Rect);
    get frame(): _Rect;
    get foregroundColor(): number;
    set foregroundColor(newcol: number);
    get backgroundColor(): number;
    set backgroundColor(newcol: number);
    fill(pat: string): void;
    moveTo(x: number, y: number): boolean;
    put(str: string): void;
}
