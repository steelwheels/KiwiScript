# ValueTable
The `ValueTable` class supports record based access on the [ValueStorage](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueStorage.md) data.

The `ValueTable` has multiple [ValueRecord](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueRecord.md)s.

## Constructor
There is a constructor function to allocate the instance of this class:
````
ValueTable(path: string, storage: ValueStorageIF): ValueTableIF ;
````

The parameter `path` is used to select the sub-tree in the storage. It is an array of strings to point the node in the storage. The pointed not *must be array of dictionaries*.

See the following storage:
````
{
        section_a: {
                records: [
                        {field: "a", value 0},
                        {field: "a", value 0},
                ]
        }
}
````


When you want to access `records` section as value table, give `"section_a.records"` for `path` parameter.

## Interface
````
interface ValueTableIF {
  recordCount:                  number ;

  readonly allFieldNames:       string[] ;
  activeFieldNames:             string[] ;

  newRecord():		ValueRecordIF ;
  record(row: number):	ValueRecordIF | null ;
  append(record: ValueRecordIF): void ;
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

### Method: `newRecord()`
Allocate new empty record. You have to append this record to the value table (which allocate the record). It is not alloed to append to the other table instance.

### Method: `record(row: number): ValueRecordIF | null`
Get the record by index number. The valid value of parameter `row` is 0..<`recordCount`. If the invalid parameter is given, this method returns `null`.

### Method: `append(record: ValueRecordIF): void`
Append the record to the table. The table will be updated by this method. The record must be allocate by `newRecord()`.

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



