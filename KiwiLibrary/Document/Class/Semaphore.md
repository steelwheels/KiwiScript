# Semaphore class
Semaphore object

## Allocator
The `Semaphore` class is used to synchronize multi threaded operations.
````
let semaphore = new Semaphore(0) ;
````
The integer parameter has initial counter value.

## Methods
### `signal` method
````
semaphore.signal() ;
````
This method decrement the counter.


### `wait` method
````
semaphore.unlock() ;
````
This method wait the counter value become smaller than zero.

# References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
