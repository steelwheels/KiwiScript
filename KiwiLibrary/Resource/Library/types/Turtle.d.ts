/// <reference path="Builtin.d.ts" />
declare type TurtleStatus = {
    x: number;
    y: number;
    angle: number;
};
declare class Turtle {
    mContext: _GraphicsContext;
    mCurrentX: number;
    mCurrentY: number;
    mCurrentAngle: number;
    mMovingAngle: number;
    mMovingDistance: number;
    mPenSize: number;
    mHistory: TurtleStatus[];
    constructor(ctxt: _GraphicsContext);
    setup(x: number, y: number, angle: number, pen: number): void;
    get logicalFrame(): _Rect;
    get currentX(): number;
    get currentY(): number;
    get currentAngle(): number;
    get movingAngle(): number;
    set movingAngle(newval: number);
    get movingDistance(): number;
    set movingDistance(newval: number);
    get penSize(): number;
    set penSize(newval: number);
    forward(dodraw: boolean): void;
    turn(doright: boolean): void;
    push(): void;
    pop(): void;
    exec(commands: string): void;
}
