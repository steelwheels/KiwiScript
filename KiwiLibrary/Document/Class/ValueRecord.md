# ValueRecord
The `ValueRecords` class presents the record data in database. This instance is allocated by [ValueTavle](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueTable.md).

## Constructor
There is no constructor function. The instance will be allocated by `newRecord` or `record` method (or the other methods) of the [ValueTable](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Class/ValueTable.md) class.

## Interface
````
interface ValueRecordIF {
	fieldNames:		[string] ;
	filledFieldNames:	[string] ;

	value(name: string):			any ;
	setValue(value: any, name: string):	boolean
}
````

## Reference
[Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): The library which contains this class.
