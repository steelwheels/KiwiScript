# Table class
Table class has 2D array of immediate values.
This class support load/save operation from/to the file. The file format is defined as [JSON: JavaScript object notation](https://en.wikipedia.org/wiki/JSON).

## Constructor
The instance of this class is allocated as a property of [Data table component](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Components/Table.md).

## Properties
### `columnCount`: Number
The integer value to present number of columns.

### `rowCount`: Number
The integer value to present number of rows.


## Methods
### `title(index: Int): String`
Get title of the column.

### `setTitle(index: Int, title: String): Void`
Set the title of the column.

### `value(columnIndex: Int, rowIndex: Int): Any`
Get the value on the table. If the value is NOT set, the return value is `null`.

### `setValue(columnIndex: Int, rowIndex: Int, value: Any)`
Set the value to the table.

## Related Links
* [Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The built-in JavaScript library.

