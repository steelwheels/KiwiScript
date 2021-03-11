# Lock class
The mutex lock object.

## Allocator
The built-in `Lock` function is used allocate instance of `Lock` class.
````
let lockobj = Lock() ;
````

## Methods
### `lock` method
Lock operation
````
lockobj.lock() ;
````

### `unlock` method
Unlock operation
````
lockobj.unlock() ;
````

### `discard` method
Release lock resource in the instance.
This method must be called after using this object.
````
lockobj.discard() ;
````

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
