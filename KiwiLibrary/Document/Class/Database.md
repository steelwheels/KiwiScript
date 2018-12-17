# Database Class

## Introduction
The `Database` defines the API for database access.
This object will be returned by the component object.

## Methods
### `read` method
Get record named `identifier`.
````
read(identifier: String) -> Object?
````
#### Return value
The record object. When the record is not found,
this value will be `undefined`.

### `write` method
Update record in the database.
````
write(identifier: String, value: Dictionary<String, Any>) -> Bool
````
#### Return value
When the writing is succeeded, this value will be 'true'.

### `delete` method
Delete the record named `identifier`.
````
delete(identifier: String) -> Bool
````
#### Return value
When he deleting is succeeded, this value will be 'true'.

### `commit` method
Tell the database that creating and writing records are finished.
````
commit(Void) -> Void
````

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
