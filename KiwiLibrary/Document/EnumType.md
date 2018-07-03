# Built-in Enum Types
This document describes about built-in enum types.

## Authorize type
The authorize type has the state of the authorization process.
### Properties
Following properties are used to specify the authorize types.
Every properties has unique signed integer values:
* `Authorize.undetermined`
* `Authorize.denied`
* `Authorize.authorized`

## Color Type
The Color class has the table of colors for console.
### Properties
Following properties are used to specify the color. Every properties has unique signed integer values:
* `Color.black`
* `Color.red`
* `Color.green`
* `Color.yellow`
* `Color.blue`
* `Color.magenta`
* `Color.cyan`
* `Color.white`

Following properties are used to traverse all colors:
* `Color.min` : The color which has minimum properties
* `Color.max` : The color which has maximum properties

You can traverse all colors by following statement:
````
for(let col=Color.min ; col<=Color.max ; col++){
  ...
}
````

## Align Type
The `Align` object has the table of kinds of alignment.
### Properties
Following properties are used to specify the alignment. Every properties has signed integer values:
* `Align.left`
* `Align.center`
* `Align.right`
* `Align.top`
* `Align.middle`
* `Align.bottom`

## Related link
* [KiwiLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/README.md): This framework contains this class.
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
