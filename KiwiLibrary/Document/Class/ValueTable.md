# ValueTable
The `ValueTable` class supports key-value access on the [ValueStorage](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueStorage.md) data. 

The `ValueTable` has multiple `ValueRecord`.

## Constructor
There is a constructor function to allocate the instance of this class:
````
ValueTable(path: [string], storage: ValueStorageIF): ValueTableIF ;
````

The parameter `path` is array of strings to point the node in the storage. See the following storage:
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

When you want to access `records` section as value table, give `["section_a", "records"]` for `path` parameter.

## Interface
````
interface ValueTableIF {
	recordCount:            number ;
	newRecord():		ValueRecordIF ;
	record(row: number):	ValueRecordIF | null ;
	append(record: ValueRecordIF): void ;
}
````

## Reference
[Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The library which contains this class.



