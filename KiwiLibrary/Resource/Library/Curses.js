"use strict";
/*
 * Curses.js
 */
/// <reference path="types/Builtin.d.ts"/>
/// <reference path="types/Enum.d.ts"/>
class CFrame {
    constructor(frame) {
        this.mFrame = frame;
        this.mCursorX = 0;
        this.mCursorY = 0;
        this.mForegroundColor = Curses.foregroundColor;
        this.mBackgroundColor = Curses.backgroundColor;
    }
    get frame() { return this.mFrame; }
    get foregroundColor() {
        return this.mForegroundColor;
    }
    set foregroundColor(newcol) {
        this.mForegroundColor = newcol;
    }
    get backgroundColor() {
        return this.mBackgroundColor;
    }
    set backgroundColor(newcol) {
        this.mBackgroundColor = newcol;
    }
    fill(pat) {
        const x = this.mFrame.x;
        const y = this.mFrame.y;
        const width = this.mFrame.width;
        const height = this.mFrame.height;
        Curses.foregroundColor = this.mForegroundColor;
        Curses.backgroundColor = this.mBackgroundColor;
        Curses.fill(x, y, width, height, pat);
    }
    moveTo(x, y) {
        if (0 <= x && x < this.mFrame.width
            && 0 <= y && y < this.mFrame.height) {
            this.mCursorX = x;
            this.mCursorY = y;
            return true;
        }
        else {
            return false;
        }
    }
    put(str) {
        let mstr = `${str}`;
        const maxlen = this.mFrame.width - this.mCursorX;
        if (maxlen <= 0) {
            return; // No spaces to put
        }
        else if (maxlen < mstr.length) {
            mstr = mstr.substr(0, maxlen);
        }
        Curses.foregroundColor = this.mForegroundColor;
        Curses.backgroundColor = this.mBackgroundColor;
        Curses.moveTo(this.mFrame.x + this.mCursorX, this.mFrame.y + this.mCursorY);
        Curses.put(mstr);
    }
}
