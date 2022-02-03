# Turtle class
The `Turtle` class is built-in JavaScript class. It uses [GraphicsContext](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/GraphicsContext.md) in it.

## Example
![Turtle graphics](https://github.com/steelwheels/KiwiScript/tree/master/KiwiLibrary/Document/Images/turtle-graphics.png)

You can see the entire script at [turtle.jspkg](https://github.com/steelwheels/JSTerminal/tree/master/Resource/Sample/turtle.jspkg).

## Interface
This is the declaration of `Turtle` class:
````
declare type TurtleStatus = {
    x: number;
    y: number;
    angle: number;
};
declare class Turtle {
    constructor(ctxt: GraphicsContextIF);
    setup(x: number, y: number, angle: number, pen: number): void;
    get logicalFrame(): RectIF;
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

````

## Methods
### `setup` method
Initialize the pen. Set position and size.
````
setup(x: number, y: number, angle: number, pen: number): void;
````
|Parameter      |Type   |Description                    |
|:---           |:---   |:---                           |
|x              |number |Initial X position             |
|y              |number |Initial Y position             |
