# Color type
The Color class has the table of colors for console.

## Properties
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

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library

