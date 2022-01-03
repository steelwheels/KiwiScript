# ValueStorage class
The `ValueStorage` class is used as the key-value storage.
The content of the storage can be loaded from the file
and stored into the file. 

It accepts only scalar, array and dictionary value (which can be reperesented by JSON format).
It means the class instance can not be kept by this storage.

## Constructor
There is a constructor function to allocate the instance of this class:
````
ValueStorage(ident: string): ValueStorageIF ;
````

### Parameter: `ident`
The idenfitier of the storage. It must be defined in `stoages` section in the [manifest file](https://github.com/steelwheels/JSTools/blob/master/Document/jspkg.md).

## Inferface
````
interface ValueStorageIF {
	value(path: [string]): any ;
	set(value: any, path: [string]): boolean ;
}
````
### Method: `value`
Get the value in the storage.

#### Parameter: `path`
The array of string to point the location in the storage.
For example,  `["a", "b", "c"]` is treated as `a.b.c`.
The "a" is the property name in the root dictionary in the storage. The "b" is the property in the "a" dictionary.
And "c" is the property in the "b" dictionary.

#### Return value
The value is `null` when there is no value at the given path.

### Method: `set`
Set the value to the storage. 

#### Parameter: `path`
See above.

#### Parameter: `value`
The scalar, array, dictionary or combination of them.
It can be represented by JSON format.

## Declaration
The location of the file to the storage is defined in [manifest file](https://github.com/steelwheels/JSTools/blob/master/Document/jspkg.md).