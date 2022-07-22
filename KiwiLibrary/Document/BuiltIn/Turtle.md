# Turtle class
The `Turtle` class is built-in JavaScript class. It uses [GraphicsContext](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/GraphicsContext.md) in it.

## Example
![Turtle graphics](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Images/turtle-graphics.png)

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
### `constructor`
````
constructor(ctxt: GraphicsContextIF);
````
The paramter `context` will be given as a paramater of Event method of [Graphics2D View](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Components/Graphics2D.md).

### `setup` method
Initialize the pen. Set position and size.
````
setup(x: number, y: number, angle: number, pen: number): void;
````

|Parameter      |Type   |Description                    |
|:---           |:---   |:---                           |
|x              |number |Initial X position [pixel]     |
|y              |number |Initial Y position [pixel]     |
|angle          |number |The moving angle of the pen. The unit is *radian*. The pen will move to up when this value is 0.|
|pen            |number |The width and height of pen [pixel] |

### `forward` method
Move the turtle with current distance and current angle.
````
forward(dodraw: boolean): void;
````

### `turn` method
Turn the turtle.
````
turn(doright: boolean): void;
````
When the parameter `doright` is true, the property `movingAngle` is added. On the otherwise, the propery is subtracted.

### `push` and `pop` methods
Push/pop the current status:
````
push(): void;
pop(): void;
````

### `exec`
Execute the control commands. Each command is presented as a character:
````
exec(commands: string): void;
````

There are supported commands:
|Chacter |Command               |
|:--     |:--                   |
|`F`     |Move forward          |
|`f`     |Move backward         |
|`+`     |Turn right            |
|`-`     |Turn left             |
|`[`     |Push the current status       |
|`]`     |Pop the current status        |

## Properties
### `logicalFrame`
The logical size of view for the turtle graphics. This is read only property.
````
get logicalFrame(): RectIF;
````

### `currentX` and `currentY`
The current pen position. They are read only properties.
````
get currentX(): number;
get currentY(): number;
````

### `currentAngle`
The current angle of the turtle. This is read only property. The `turn` method change this value by adding/subtracting `movingAngle`.
````
get currentAngle(): number;
````

### `movingAngle`
The angle which is refered by `turn` method.
````
get movingAngle(): number;
set movingAngle(newval: number);
````

### `distance`
The distance which is refered by `forward` method.
````
get movingDistance(): number;
set movingDistance(newval: number);
````

### `penSize`
Get or set the size of pen:
````
get penSize(): number;
set penSize(newval: number);
````

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
* [Turtle class](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/BuiltIn/Turtle.md): Buillt-in JavaScript class for turtle graphics.
