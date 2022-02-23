# Dictionary

The `Dictionary` has multiple value that they are linked with the unique identifier strings.

This object is used to transfer beyond the JavaScript context. The contents of this object will be converted into native value and re-allocated fot the destination context.

## Constructor function
````
Dictionary() : DictionaryIF
````

## Interface
````
interface DictionaryIF {
  setNumber(name: string, value: number): void ;
  setString(name: string, value: string): void ;

  number(name: string): number | null ;
  string(name: string): string | null ;
}
````

### `setNumber`
Set the number value with key name.
````
setNumber(name: string, value: number): void ;
````

### `setString`
Set the string value with key name.
````
setString(name: string, value: string): void ;
````

### `number`
Get the number value by the key.
If there are no value for given key, the return value will be `null`.
````
number(name: string): number | null ;
````

### `string`
Get the string value by the key.
If there are no value for given key, the return value will be `null`.
````
string(name: string): string | null ;
````

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
