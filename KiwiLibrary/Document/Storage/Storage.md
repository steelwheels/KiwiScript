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

## Related links
* [KiwiLibrary](https://github.com/steelwheels/KiwiScript/tree/master/KiwiLibrary): The framework which defines the API for storage.
