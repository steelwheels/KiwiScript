# Enum: Comparison result

The `CompariosnResult` presents the result of comparison: *ascending*, *same* or *descending*.

## Properties
Following properties are used to specify the result of comparison:
````
ComparisonResult.ascending
ComparisonResult.descending
ComparisonResult.same
````
For example, `compare(1, 2)` will return `ComparisonResult.ascending` because the left item is smaller than right.
And `compare(4, 3)` will return `ComparisonResult.descending` because the left item is bigger than right.

## References
* [Kiwi Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md): Document for this library
