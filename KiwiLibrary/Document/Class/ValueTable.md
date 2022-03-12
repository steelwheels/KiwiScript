# ValueTable
The `ValueTable` class supports record based access on the [ValueStorage](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueStorage.md) data.

The `ValueTable` has multiple [Record](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Record.md)s.

## File format
This is a sample JSON data for value table.

The format of the sub-tree is defined as `ValueTable` format.

Filen ame: `sample.json`
````
{
        top: {
                className: "ValueTable",
                columnNames: [
                        "a", "b"
                ],
                records: [
                        {field: "a", value 0},
                        {field: "b", value 0},
                ]
        }
}
````

|Property       |Type   |Description                    |
|:--            |:--    |:--                            |
|`className`    |string |Must be "`ValueTable`"         |
|`columnNames`  |string[] |Name of columns             |
|`records`      |object[] |Array of record objects      |


## Constructor
There is a constructor function to allocate the instance of this class:
````
ValueTable(path: string, storage: ValueStorageIF): ValueTableIF ;
````

The parameter `path` is used to select the sub-tree in the storage. When you want to access value table in above `sample.json`,
give "`top`" as a parameter for the `path`.

## Interface
````
interface ValueTableIF {
        recordCount:		number ;

	readonly allFieldNames:	string[] ;

	record(row: number):			RecordIF | null ;
	search(value: any, name: string):	RecordIF[] | null ;
	append(record: RecordIF): 		void ;

	toString(): 		string
}
````

### Property: `recordCount`
Number of the records in the table. The values is zero or positive integer.

### Property: `allFieldNames`
Collect field names from all records in the table.

### Property: `activeFieldNames`
The [TableView](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Components/Table.md) displays fields which defined by this property.
You can choose visible fields against all fields.

The initial value is `[]` (empty), in this case the value of `allFieldNames` is used as this value.

### Method: `record(row: number): RecordIF | null`
Get the record by index number. The valid value of parameter `row` is 0..<`recordCount`. If the invalid parameter is given, this method returns `null`.

### Method: `append(record: RecordIF): void`
Append the record to the table. The table will be updated by this method. The record must be allocate by `newRecord()`.

### Method: `toString(): string`
Return the string which presents the entire of table data.

## Sample script
This is sample script to allocate ValueTable.
About allocation of ValueStorage, see [ValueStorage](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueStorage.md).
````
  let storage = ValueStorage("storage") ;
  let table = ValueTable("path", storage) ;
````
(These functions returns `null` when the allocation failed. You have to check them at the real implementation.)

After the allocation, you can access properties of them:
````
let count = table.recordCount ;
console.print("recode-count = " + count + "\n") ;

let fnames = table.allFieldNames ;
console.print("all-field-names = " + fnames + "\n") ;
````

## Reference
[Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The library which contains this class.



