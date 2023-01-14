# Table
The `Table` class manages the multiple [Record](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Record.md) data and infomation for rows and columns.
The data is placed as a part of [Storage](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueStorage.md).

The `Table` has multiple .

## File format
This is a sample JSON data for value table.

The format of the sub-tree is defined as `Table` format.

````
{
        top: {
                className: "Table",
                defaultFields: [
                        "a":    0,
                        "b":    0
                ],
                records: [
                        {field: "a", value 0},
                        {field: "b", value 0},
                ]
        }
}
````

|Element        |Type   |Description                    |
|:--            |:--    |:--                            |
|`className`    |string |Must be "`Table`"         |
|`defaultFields` |[string:any][] |array of {field-name, initial-value}             |
|`records`      |object[] |Array of record objects      |

## Constructor
There is a constructor function to allocate the instance of `Table` class:
````
Table(path: string, storage: StorageIF): TableDataIF ;
````

The parameter `path` is used to select the sub-tree in the storage. When you want to access value table in above `sample.json`,
give "`top`" as a parameter for the `path`.

## Interface
````
interface TableDataIF {
  recordCount:		        number ;
  readonly defaultFields:	{[name:string]: any} ;

  record(row: number):			RecordIF | null ;
  pointer(value: any, key: string):	any | null ;

  search(value: any, name: string):	RecordIF[] | null ;
  append(record: RecordIF): 		void ;
  appendPointer(pointer: any):		void ;

  remove(index: number):                boolean ;
  save():                               boolean ;

  toString(): 		                string ;
}
````

### Property: `recordCount`
Number of the records in the table. The values is zero or positive integer.

### Property: `defaultFields`
Array of fieds. Field contains the field name and initial value.

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
About allocation of Storage, see [Storage](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueStorage.md).
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



