# Table class
The table contains mutiple records.


## Interface
````
interface TableIF {
  recordCount:		                number ;

  readonly allFieldNames:	string[] ;

  record(row: number):			RecordIF | null ;
  pointer(value: any, key: string):	any | null ;

  search(value: any, name: string):	RecordIF[] | null ;
  append(record: RecordIF): 		void ;
  appendPointer(pointer: any):		void ;

  remove(index: number):			boolean ;
  save():					boolean ;

  toString(): 		string ;
}
````

## Constructor
There is built-in function to allocate value table.
````
Table(path: string, storage: StorageIF): TableIF | null ;
````

|name   |Type   |Description    |
|:--    |:--    |:--            |
|`path`    |string |Location in the storage |
|`storage` |[Storage](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/Storage.md) |On memory file storage |

The `path` is multiple strings joined by period(`.`).
For example, the path for `table_a` in the next storage
is presented as `tables.table_a`.
````
{
  tables: {
        table_a: {
                class: "Table",
                columnNames: ["c0", "c1", "c2"],
                records: [
                        ...
                ]
        }
  }
}
````

## Properties
### `recordCount`
````
recordCount: number
````
Number of records in the table.

## Related Links
* [Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The built-in JavaScript library.

