# Table
The `Table` class supports record based access on the [Storage](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Storage.md) data.

The `Table` has multiple [Record](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Record.md)s.

## File format
This is a sample JSON data for value table.

The format of the sub-tree is defined as `Table` format.

Filen ame: `sample.json`
````
{
        top: {
                className: "Table",
                columnNames: [
                        "a", "b"
                ],
                records: [
                        {field: "a", value 0},
                        {field: "b", value 0},
                ],
                default: {
                        a:      0,
                        b:      0
                }
        }
}
````

|Property       |Type   |Description                    |
|:--            |:--    |:--                            |
|`className`    |string |Must be "`Table`"         |
|`columnNames`  |string[] |Name of columns             |
|`records`      |object[] |Array of record objects      |
|`default`      |dictionary |Dictionary which contains default values of the record |

## Constructor
There is a constructor function to allocate the instance of this class:
````
Table(path: string, storage: StorageIF): TableIF ;
````

The parameter `path` is used to select the sub-tree in the storage. When you want to access value table in above `sample.json`,
give "`top`" as a parameter for the `path`.

## Interface
````
interface TableIF {
        recordCount:		number ;

	readonly allFieldNames:	string[] ;

	record(row: number):			RecordIF | null ;
	pointer(value: any, key: string):	any | null ;

	search(value: any, name: string):	RecordIF[] | null ;
	append(record: RecordIF): 		void ;
        appendPointer(pointer: any):		void ;

        remove(index: number):			boolean ;
	save():					boolean ;

	toString(): 		                string ;
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

### Method: `pointer(value: any, key: string):	any | null`
Get the pointer of the record in the table. The field name `key` and value of it is used to select the record in the table.
````
pointer(value: any, key: string):	any | null ;
````

### Method: `search(value: any, name: string):	RecordIF[] | null ;`
Get the record in the table. The field name `key` and value of it is used to select the record in the table.

### Method: `append(record: RecordIF): void`
Append the record to the table.
The table will be updated by this method.

### Method: `appendPointer(pointer: any): void ;`
Append the pointer as the record in the table.
The table will be updated by this method.

### Method: `remove(index: number): boolean ;`
Remove the record in the table which is indexed by `index`.

### Method: `save(): boolean`
Save the storage which contains this table.

### Method: `toString(): string`
Return the string which presents the entire of table data.

## Sample script
This is sample script to allocate Table.
About allocation of Storage, see [Storage](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Storage.md).
````
  let storage = Storage("storage") ;
  let table = Table("path", storage) ;
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



