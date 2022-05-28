# Enum specification

## Introduction
You can define the custom enum type in the file. The file has [enum format](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Format/EnumFormat.md). The file must registered in the `definitions` section in the [manifest file](https://github.com/steelwheels/JSTools/blob/master/Document/jspkg.md).

This is a sample definition of enum file. The file name is `enum.json`.
````
{
    class: "enumTable",
    definitions: {
        Weekday: {
            sun:        0,
            mon:        1,
            tue:        2,
        }
    }
}
````

This is the sample manifest file which loads the enum type definition in the `enum.json` file.
````
{
    application: "main.js",
    definitions: [
        "enum.json"
    ]
}
````

You can use the enum type and value in your script. The following table contains enum types:
* `FontSize`: Built-in enum type
* `Weekday`:  Scripted enum type
````
{
    root: {
        class: "Table",
        defaultFields: {
            week:   Weekday.sun,
            size:   FontSize.small,
            day:    1
        },
        records: [
            {
                week:   Weekday.sun,
                size:   FontSize.regular,
                day:    2
            },
        ...
        ]
    }
}
````

You can see the entire sample script at [enum-1.jspkg](https://github.com/steelwheels/JSTerminal/tree/master/Resource/Sample/enum-1.jspkg).

## TypeScript support
````
declare enum Weekday {
    sun = 0,
    mon = 1,
    tue = 2
}
declare namespace Weekday {
    function description(day: Weekday): string;
}
````

# Reference
* [Enum section in TypeScript Deep Dive](https://typescript-jp.gitbook.io/deep-dive/type-system/enums): Japanese edition
* [Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): JavaScript library
* [Steel Wheels Project](http://steelwheels.github.io): The developer of this software.

