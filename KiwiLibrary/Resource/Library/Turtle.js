"use strict";
/*
 * turtle.ts: Support Turtle Graphics
 */
/// <reference path="types/Builtin.d.ts"/>
class Turtle {
    constructor(ctxt) {
        this.mContext = ctxt;
        this.mCurrentX = 0.0;
        this.mCurrentY = 0.0;
        this.mCurrentAngle = 0;
        this.mMovingAngle = Math.PI / 2.0;
        this.mMovingDistance = ctxt.logicalFrame.width / 10.0;
        this.mPenSize = this.mMovingDistance / 10.0;
        this.mHistory = [];
    }
    setup(x, y, angle, pen) {
        this.mCurrentX = x;
        this.mCurrentY = y;
        this.mCurrentAngle = angle;
        this.mPenSize = pen;
        this.mContext.moveTo(x, y);
        this.mContext.setPenSize(pen);
    }
    get logicalFrame() { return this.mContext.logicalFrame; }
    get currentX() { return this.mCurrentX; }
    get currentY() { return this.mCurrentY; }
    get currentAngle() { return this.mCurrentAngle; }
    get movingAngle() { return this.mMovingAngle; }
    set movingAngle(newval) { this.mMovingAngle = newval; }
    get movingDistance() { return this.mMovingDistance; }
    set movingDistance(newval) { this.mMovingDistance = newval; }
    get penSize() { return this.mPenSize; }
    set penSize(newval) {
        this.mContext.setPenSize(newval);
        this.mPenSize = newval;
    }
    forward(dodraw) {
        this.mCurrentX += Math.sin(this.mCurrentAngle) * this.mMovingDistance;
        this.mCurrentY += Math.cos(this.mCurrentAngle) * this.mMovingDistance;
        if (dodraw) {
            this.mContext.lineTo(this.mCurrentX, this.mCurrentY);
        }
        else {
            this.mContext.moveTo(this.mCurrentX, this.mCurrentY);
        }
    }
    turn(doright) {
        if (doright) {
            this.mCurrentAngle += this.mMovingAngle;
        }
        else {
            this.mCurrentAngle -= this.mMovingAngle;
        }
    }
    push() {
        let obj = {
            x: this.mCurrentX,
            y: this.mCurrentY,
            angle: this.mCurrentAngle
        };
        this.mHistory.push(obj);
    }
    pop() {
        let ret = this.mHistory.pop();
        if (!isUndefined(ret)) {
            let stat = ret; // Cast force
            if (!isUndefined(stat.x)) {
                this.mCurrentX = stat.x;
            }
            else {
                console.error("[Error] No X property in Turtle\n");
            }
            if (!isUndefined(stat.y)) {
                this.mCurrentY = stat.y;
            }
            else {
                console.error("[Error] No Y property in Turtle\n");
            }
            if (!isUndefined(stat.angle)) {
                this.mCurrentAngle = stat.angle;
            }
            else {
                console.error("[Error] No angle property in Turtle\n");
            }
            /* Update current position */
            this.mContext.moveTo(this.mCurrentX, this.mCurrentY);
        }
        else {
            console.error("[Error] No history in Turtle\n");
        }
    }
    exec(commands) {
        let cmdlen = commands.length;
        for (let i = 0; i < cmdlen; i++) {
            let cmd = commands.charAt(i);
            switch (cmd) {
                case "F":
                    this.forward(true);
                    break;
                case "f":
                    this.forward(false);
                    break;
                case "+":
                    this.turn(true);
                    break;
                case "-":
                    this.turn(false);
                    break;
                case "[":
                    this.push();
                    break;
                case "]":
                    this.pop();
                    break;
                default:
                    console.error(`[Error] Unknown turtle command: ${cmd}\n`);
                    break;
            }
        }
    }
}
