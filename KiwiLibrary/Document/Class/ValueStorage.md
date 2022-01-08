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
	store(): void ;
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

### Method: `store`
Save the contents of strage into the file. This method *does not* overwrite the original data file. The generated file will be placed under `~/Library/Containers/github.com.steelwheels.JSTerminal/Data/Library/Application\ Support/<package-name>.jspkg/` directory.

## Declaration
The location of the file to the storage is defined in [manifest file](https://github.com/steelwheels/JSTools/blob/master/Document/jspkg.md). This is sample description:
````
{
	application: "main.js"
	storages: {
		storage0: "data/storage0.json"
	}
}
````
The load/store file for the value storage named `storage0` is placed at `*.jspkg/data/storage0.json`. The file will loaded at the boot timing of same script.

## Example
Following JavaScript allocates the value storage which is defined in above manifest file.
````
let storage0 = ValueStorage("storage0") ;
if(storage0 == null){
	console.log("Failed to allocate") ;
	return -1 ;
}
````
Following script calls `value` and `setValue` methods:
````
let vala = storage0.value(["a"]) ;
console.log("a = " + vala) ;

storage0.set(1234, ["b"]) ;
let valb = storage0.value(["b"]) ;
console.log("b = " + valb) ;
````
Following script calls `store` method:
````
if(storage0.store()){
	console.print("OK\n") ;
} else {
	console.print("Failed\n") ;
}
````
The file `~/Library/Containers/github.com.steelwheels.JSTerminal/Data/Library/Application\ Support/storage0.jspkg/data/storage0.json` will be generated.

You can see the entire sample script at [storage0.jspkg](https://github.com/steelwheels/JSTerminal/tree/master/Resource/Sample/storage0.jspkg).

# References
* [Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md)

