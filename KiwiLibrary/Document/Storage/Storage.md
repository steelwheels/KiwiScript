# Storage

## Overview

The *storage* is persisten data. The text file is used to keep
the contents of data. The file will be loade by the application
and updated.
The fomat of the file is defined in [storage file format](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Format/StorageFormat.md).

## Storage data type
* [Table storage](TableStorage.md): The data structure for database. The table has the sequence of [data records](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Record.md).
* [Dictionary storage](DictionaryStorage.md): The dictionary data in storage. The key is property name (typed `string`) and the value is scalar value.
* [Array storage](ArrayStorage.md): The data structure for database. The table has the sequence of scalar values.

## File
### File location
The file to define initial value for storage is stored in application package (`*.jspkg`). The application will make the copy and put it to `~/Library` directory.The copied file under `~/Library` directory will be updated by the application.

### Manifest file
The location of the storage file will be defined in the storage section in [manifest file](https://github.com/steelwheels/JSTools/blob/master/Document/jspkg.md).

## Format and API
The table, dictionary and array storage(s) can be allocated in a storage file.
* [table](./TableStorage.md)
* [dictionary](./DictionaryStorage.md)
* [array](./ArrayStorage.md)

## Related links
* [KiwiLibrary](https://github.com/steelwheels/KiwiScript/tree/master/KiwiLibrary): The framework which defines the API for storage.
