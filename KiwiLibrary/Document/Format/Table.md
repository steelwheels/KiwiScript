# Format: Table
There are 2 kind of data structure to present the table.

## Sheet
The *sheet* has 2D data array for the table element.
The data can be encoded to/decoded from [HTML Table](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/table).

````
{
        headers: ["col0", "col1", ..., "colN"],
        data: [
                ["val0/0", "val0/1", ..., "val0/N"],
                ["val1/0", "val1/1", ..., "val1/N"],
                ...
                ["valM/0", "valM/1", ..., "valM/N"],
        ]
}
````

The *headers* section defines the column titles on the table. If this section is NOT exist, the default tolumn title is assigned.

The *data* secion has 2D value array. It presents the array of row data. If each row has different number of elements, the null data is added to adjust there sizes.

|col0   |col1   |...    |colN   |
|:--    |:--    |:--    |:--    |
|val0/0 |val0/1 |..     |val0/N |
|val1/0 |val1/1 |..     |val1/N |
|valM/0 |valM/1 |..     |valM/N |


## Cards
The array of objects. The object is used to present the card data.

````
[
        card0: {
                col0: "val0/0",
                col1: "val0/1",
                ...
        },
        card1: {
                col0: "val1/0",
                col1: "val1/1",
                ...
        },
        ...
]
````

The card has multiple properties. The property consists of  unique key string (= the "col0" in above example) and single scalar value. Each key string will be a column title.

|#      |col0           |col1           |...    |colN |
|:--    |:--            |:--            |:--    |:--    |
|card0  |val0/0         |val0/1         |...    |val0/N |
|card1  |val1/0         |val1/1         |...    |val1/N |

# Rerefence
* [Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md)
