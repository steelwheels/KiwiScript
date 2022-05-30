/// <reference path="Builtin.d.ts" />
/// <reference path="Enum.d.ts" />
declare class CFrame {
    mFrame: RectIF;
    mCursorX: number;
    mCursorY: number;
    mForegroundColor: number;
    mBackgroundColor: number;
    constructor(frame: RectIF);
    get frame(): RectIF;
    get foregroundColor(): number;
    set foregroundColor(newcol: number);
    get backgroundColor(): number;
    set backgroundColor(newcol: number);
    fill(pat: string): void;
    moveTo(x: number, y: number): boolean;
    put(str: string): void;
}
