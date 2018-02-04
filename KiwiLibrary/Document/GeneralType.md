# General purpose types

## Authorize type
The authorize type has the state of the authorization process.
### Properties
Following properties are used to specify the authorize types.
Every properties has unique signed integer values:
* `Authorize.Undetermined`
* `Authorize.Denied`
* `Authorize.Authorized`

## Color Type
The Color class has the table of colors for console.
### Properties
Following properties are used to specify the color. Every properties has unique signed integer values:
* `Color.Black`
* `Color.Red`
* `Color.Green`
* `Color.Yellow`
* `Color.Blue`
* `Color.Magenta`
* `Color.Cyan`
* `Color.White`

### Utility properties
Following properties are used to traverse all colors:
* `Color.Min` : The color which has minimum properties
* `Color.Max` : The color which has maximum properties

You can traverse all colors by following statement:
````
for(let col=Color.Min ; col<=Color.Max ; col++){
  ...
}
````

## Align Type
The Align class has the table of kinds of alignment.
### Properties
Following properties are used to specify the alignment. Every properties has signed integer values:
* `Align.Left`
* `Align.Center`
* `Align.Right`
* `Align.Top`
* `Align.Middle`
* `Align.Bottom`

### Utility methods
#### `description` method
The method to get the name of the color:
````
colorname = Color.description(Color.Red) /* -> "Red" */
````
##### Parameter(s)
|Parameter    |Type    |Description                    |
|:---         |:---    |:---                           |
|color        |Integer |The value of the color         |

##### Return value
The string to present the name. If the parameter is invalid for color, this value will be *nil*.

## Related link
* [KiwiLibrary](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/README.md): This framework contains this class.
* [Steel Wheels Project](http://steelwheels.github.io): Web site of developer.
